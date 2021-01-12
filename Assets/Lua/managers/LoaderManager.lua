LoaderManager = class("LoaderManager");

function LoaderManager:ctor()
	self._abLoaders = {};

	self._manifest = nil;
	self._dependencies = {};
end

function LoaderManager:loadAsset(abName,assetName,callback,target)
	print("loadAsset",abName,assetName);
	local abLoader = self._abLoaders[abName];
	if self._abLoaders[abName] == nil then
		abLoader = AssetLoader:new(abName);
		self._abLoaders[abName] = abLoader;
	end
	abLoader:addCB(callback,target,assetName);
	abLoader:doLoad();
end

function LoaderManager:removeAsset(abName,assetName,callback,target)
	local abLoader = self._abLoaders[abName];
	if abLoader ~= nil then
		abLoader:removeCB(callback,target);
		if abLoader:isCanRemove() then
			self._abLoaders[abName]:dispose();
			self._abLoaders[abName] = nil;
		end
	end
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
		return {abName};
	end
	local depends = self._dependencies[abName];
	if depends == nil then
		local tmp = self._manifest:GetAllDependencies(abName);
		depends = {};
		for i=0, tmp.Length-1, 1 do
			print("getDependList",tmp[i]);
			table.insert(depends, tmp[i]);
		end
		table.insert(depends, abName);
		self._dependencies[abName] = depends;
	end
	return depends;
end

function LoaderManager:getDependListOfficial(abName)
	if(self.abManifest == nil)then
		return nil;
	end
	local dep = self._abDependencies[abName];
	if(dep == nil)then
		local tmp = self.abManifest:GetAllDependencies(abName);
		dep = {};
		local len = tmp.Length;
		for i = 0,len - 1,1 do
			table.insert(dep,tmp[i]);
		end
		self._abDependencies[abName] = dep;
	end
	return dep;
end

function LoaderManager:clearAll()
	for k,v in pairs(self._abLoaders) do
		v:dispose();
		self._abLoaders[k] = nil;
	end
end