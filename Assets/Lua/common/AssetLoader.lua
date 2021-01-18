--加载类（单个ab包，text,bytes,texture)
AssetLoader = class("AssetLoader");

function AssetLoader:ctor(abName)
	self.text = nil;
	self.bytes = nil;
	self.texture = nil;
	--引用计数
	self.count = 0;
	--ab里面的内容
	self.abContent = nil;

	--0:assetbundle,1:text,2:bytes,3:texture
	self.loadType = 0;

	self._cbs = {};
	self.abName = abName;
	--0:等待，1：加载中，2：加载完成
	self.loadState = 0;
end

function AssetLoader:doLoad()
	if(self.loadState == 0)then
		self.loadState = 1;
		StartCoroutine(function() self:__load(); end);
	elseif(self.loadState == 2)then
		self:loadComplete();
	end
end

function AssetLoader:__load()
	local download = nil;
	local resPath = gameConfig:getResFoldPath().."/"..self.abName;
	-- print("resPath=",resPath);
	if self.loadType == 0 then
		download = UnityEngine.AssetBundle.LoadFromFileAsync(resPath);
	else
		download = UnityEngine.WWW(resPath);
	end

	Yield(download);
	if(self.loadType ~= 0 and download.error ~= "" and download.error ~= nil)then
		print("加载出错了",download.error,resPath);
	else
		if self.loadType == 0 then
			self.abContent = download.assetBundle;
		elseif self.loadType == 1 then
			self.text = download.text;
		elseif self.loadType == 2 then
			self.bytes = download.bytes;
		elseif self.loadType == 3 then
			self.texture = download.texture;
		end
		self:loadComplete();
	end
	if self.loadType ~= 0 then
		download:Dispose();
	end
	download = nil;
end

function AssetLoader:setLoadType(loadType)
	self.loadType = loadType;
end


function AssetLoader:addCB(callback,target)
	local index = self:hasCB(callback,target);
	if(index == -1)then
		local qd = globalManager.poolManager:createQuoteData();
		qd:init(callback,target);
		table.insert(self._cbs,qd);
		if(self.loadState == 2)then
			self:doCallBack(qd);
		end
	else
		print("AssetLoader重复添加加载回调");
	end
end

function AssetLoader:removeCB(callback,target)
	local index = self:hasCB(callback,target);
	if(index > -1)then
		local qd = table.remove(self._cbs,index);
		qd:dispose();
	end
end

function AssetLoader:hasCB(callback,target)
	local len = #self._cbs;
	local qd = nil;
	for i = 1,len,1 do
		qd = self._cbs[i];
		if(qd.callback == callback and qd.target == target)then
			return i;
		end
	end
	return -1;
end

function AssetLoader:loadComplete()
	self.loadState = 2;
	local len = #self._cbs;
	for i = len,1,-1 do
		local qd = table.remove(self._cbs,i);
		self:doCallBack(qd);
	end
end

function AssetLoader:doCallBack(qd)
	if self.loadType == 0 then
		qd.callback(qd.target,self.abName);
	elseif self.loadType == 1 then
		qd.callback(qd.target,self.abName,qd.params,self.text);
	elseif self.loadType == 2 then
		qd.callback(qd.target,self.abName,qd.params,self.bytes);
	elseif self.loadType == 3 then
		qd.callback(qd.target,self.abName,qd.params,self.texture);
	end
end

function AssetLoader:addCount()
	self.count = self.count + 1;
end

function AssetLoader:reduceCount()
	self.count = self.count - 1;
end

function AssetLoader:isCanRemove()
	return self.count <= 0;
end

function AssetLoader:dispose()
	if self._cbs ~= nil then
		for i=1,#self._cbs do
			self._cbs[i]:dispose();
		end
	end
	self._cbs = nil;
	self.text = nil;
	self.bytes = nil;
	self.texture = nil;
	
	if self.abContent ~= nil then
		self.abContent:Unload(false);
	end
	self.abContent = nil;
end
