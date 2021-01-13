LoaderManager = class("LoaderManager");

function LoaderManager:ctor()
	self._abLoaders = {};
	self._assetLoaders = {};


	self._manifest = nil;
	self._dependencies = {};
end

function LoaderManager:loadAB(abName,assetName,callback,target)
	-- print("LoaderManager:loadAB",abName,assetName);
	local abLoader = self._abLoaders[abName];
	if abLoader == nil then
		abLoader = ABLoader:new(abName);
		self._abLoaders[abName] = abLoader;
	end

	abLoader:addCount();
	abLoader:addCB(callback,target,assetName);
	abLoader:startLoad();
end

function LoaderManager:removeAB(abName,assetName,callback,target)
	local abLoader = self._abLoaders[abName];
	if abLoader ~= nil then
		abLoader:reduceCount();
		abLoader:removeCB(callback,target,assetName);
		if abLoader:isCanRemove() then
			abLoader:dispose();
			self._abLoaders[abName] = nil;
		end
	end
end

function LoaderManager:loadSingleAB(abName,callback,target)
	-- print("LoaderManager:loadSingleAB",abName);
	local assetLoader = self:getAssetLoader(abName);
	assetLoader:addCount();
	--单个ab包加载，不传assetName,当有多个ab包回调同一个函数时，只需要调用一次就好
	assetLoader:addCB(callback,target);
	assetLoader:doLoad();
end

function LoaderManager:removeSingleAB(abName,callback,target)
	local assetLoader = self._assetLoaders[abName];
	if assetLoader ~= nil then
		assetLoader:reduceCount();
		assetLoader:removeCB(callback,target);
		if assetLoader:isCanRemove() then
			assetLoader:dispose();
			self._assetLoaders[abName] = nil;
		end
	end
end

function LoaderManager:getAssetLoader(abName)
	if self._assetLoaders[abName] == nil then
		self._assetLoaders[abName] = AssetLoader:new(abName);
	end
	return self._assetLoaders[abName];
end

function LoaderManager:loadText(name,callback,target)
	local abLoader = AssetLoader:new(name);
	abLoader:setLoadType(1);
	abLoader:addCB(callback,target);
	abLoader:doLoad();
end

function LoaderManager:loadBytes(name, callback, target)
	local abLoader = AssetLoader:new(name);
	abLoader:setLoadType(2);
	abLoader:addCB(callback, target);
	abLoader:doLoad();
end

--加载png和jpg图片
function LoaderManager:loadTexture(name, callback, target)
	local abLoader = AssetLoader:new(name);
	abLoader:setLoadType(3);
	abLoader:addCB(callback, target);
	abLoader:doLoad();
end


function LoaderManager:setABManifest(data)
	self._manifest = data;
end

function LoaderManager:getDependList(abName)
	if self._manifest == nil then
		return {};
	end
	local depends = self._dependencies[abName];
	if depends == nil then
		local tmp = self._manifest:GetAllDependencies(abName);
		depends = {};
		for i=0, tmp.Length-1, 1 do
			table.insert(depends, tmp[i]);
		end
		table.insert(depends, abName);
		self._dependencies[abName] = depends;
	end
	return depends;
end

function LoaderManager:clearAll()
	for k,v in pairs(self._assetLoaders) do
		v:dispose();
		self._assetLoaders[k] = nil;
	end
end