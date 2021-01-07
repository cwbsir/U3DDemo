LoaderManager = class("LoaderManager");

function LoaderManager:ctor()
	self._abLoaders = {};

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

function LoaderManager:clearAll()
	for k,v in pairs(self._abLoaders) do
		v:dispose();
		self._abLoaders[k] = nil;
	end
end