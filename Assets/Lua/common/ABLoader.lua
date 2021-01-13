--ab包加载类（含有依赖的加载）
ABLoader = class("ABLoader");


function ABLoader:ctor(abName)
	--引用计数
	self.count = 0;

	self._cbs = {};
	self.abName = abName;
	self.abCompleteDic = {};
end

function ABLoader:startLoad()
	local curLoader = globalManager.loaderManager:getAssetLoader(self.abName);
	local isCurABComplete = curLoader.loadState == 2;
	self.abCompleteDic[self.abName] = isCurABComplete;

	local dependList = globalManager.loaderManager:getDependList(self.abName);
	for i=1,#dependList do
		local abName = dependList[i];
		local loader = globalManager.loaderManager:getAssetLoader(abName);
		local isABComplete = loader.loadState == 2;
		self.abCompleteDic[abName] = isABComplete;
		if not isABComplete then
			--加载依赖里的ab包
			globalManager.loaderManager:loadSingleAB(abName,self.checkABComplete,self);
		end
	end
	
	--加载ab包
	if not isCurABComplete then
		globalManager.loaderManager:loadSingleAB(self.abName,self.checkABComplete,self);
	end
end

function ABLoader:checkABComplete(abName)
	self.abCompleteDic[abName] = true;

	local isAllComplete = true;
	for k,v in pairs(self.abCompleteDic) do
		if not v then 
			isAllComplete = false;
			break;
		end
	end
	--加载完所有的ab包
	if isAllComplete then
		self:loadComplete();
	end
end

function ABLoader:addCB(callback,target,assetName)
	if callback == nil or target == nil then
		return;
	end

	local index = self:hasCB(callback,target,assetName);
	if(index == -1)then
		local qd = globalManager.poolManager:createQuoteData();
		qd:init(callback,target);
		qd.params = assetName;
		table.insert(self._cbs,qd);
	else
		print("ABLoader重复添加加载回调");
	end
end

--在没回调之前，可以调用此函数移除回调
function ABLoader:removeCB(callback,target,assetName)
	local index = self:hasCB(callback,target,assetName);
	if(index > -1)then
		local qd = table.remove(self._cbs,index);
		qd:dispose();
	end
end

function ABLoader:hasCB(callback,target,assetName)
	local len = #self._cbs;
	local qd = nil;
	for i = 1,len,1 do
		qd = self._cbs[i];
		--不同asset的都需要回调
		if(qd.callback == callback and qd.target == target and qd.params == assetName )then
			return i;
		end
	end
	return -1;
end

function ABLoader:loadComplete()
	if self._cbs ~= nil then
		local len = #self._cbs;
		for i = len,1,-1 do
			local qd = table.remove(self._cbs,i);
			self:doCallBack(qd);
		end
	end
end

function ABLoader:doCallBack(qd)
	local assetName = qd.params;
	local curLoader = globalManager.loaderManager:getAssetLoader(self.abName);
	local abContent = curLoader.abContent;
	if assetName ~= nil then
		local asset =  abContent:LoadAsset(assetName);
		qd.callback(qd.target,self.abName,assetName,abContent,asset);
	else
		qd.callback(qd.target,self.abName,nil,abContent);
	end
end

function ABLoader:addCount()
	self.count = self.count + 1;
end

function ABLoader:reduceCount()
	self.count = self.count - 1;
end

function ABLoader:isCanRemove()
	return self.count <= 0;
end

function ABLoader:dispose()
	for k,v in pairs(self.abCompleteDic) do
		local abName = k;
		globalManager.loaderManager:removeSingleAB(abName,self.checkABComplete,self);
	end
	if self._cbs ~= nil then
		for i=1,#self._cbs do
			self._cbs[i]:dispose();
		end
	end
	self._cbs = nil;
	
end