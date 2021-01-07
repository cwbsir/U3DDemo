TemplateParser = class("TemplateParser");

function TemplateParser:ctor()
	self._data = nil;
	self._quoteData = nil;
	self._fileCount = 0;
	self._parseInfos = {};
	self._currentParseInfo = nil;
	self._hasParseBytes = 0;
	self._maxParseBytes = 10000;
end

function TemplateParser:start(data,callback,target)
	self._quoteData = globalManager.poolManager:createQuoteData();
	self._quoteData:init(callback,target);

	local pos = 4;
	self._fileCount = data[pos + 1] * 256 + data[pos];

	-- print("self._fileCount",data[pos + 1],data[pos],self._fileCount);

	pos = pos + 2;
	for i = 1,self._fileCount,1 do
		local id = data[pos + 1] * 256 + data[pos];
		pos = pos + 2;
		local fileLen = data[pos + 3] * 16777216 + data[pos + 2] * 65536 + data[pos + 1] * 256 + data[pos];
		pos = pos + 4;
		local byteArray = ByteArray();
		-- print("fileLen",fileLen);
		byteArray:loadBytesOffset(data,pos,fileLen);
		pos = pos + fileLen;

		local templateList = self:getTempById(id);
		if(templateList ~= nil)then
			templateList.temp_id = id;
			templateList:init(byteArray,fileLen);
			table.insert(self._parseInfos,templateList);
		end
	end
	globalManager.tickManager:addTick(self.tick,self);
end

function TemplateParser:setMaxParseBytes(v)
	self._maxParseBytes = v;
end

function TemplateParser:tick(delta)
	for i = 1,1000000000,1 do
		if(self._currentParseInfo == nil)then
			if(#self._parseInfos <= 0)then
				self:doComplete();
				break;
			else
				self._currentParseInfo = table.remove(self._parseInfos,1);
			end
		else
			if(self._currentParseInfo.parseComplete1)then
				self._currentParseInfo = nil;
			else
				local dPosition = self._currentParseInfo:getCurReadPos();
				self._currentParseInfo:parse();
				dPosition = self._currentParseInfo:getCurReadPos() - dPosition;
				self._hasParseBytes = self._hasParseBytes + dPosition;
				if(self._hasParseBytes >= self._maxParseBytes)then
					self._hasParseBytes = 0;
					break;
				end
			end
		end
	end
end

function TemplateParser:getTempById(id)
	-- if id == 1 then
	-- 	return globalConst.landTemplateList;
	-- elseif id == 2 then
	-- 	return globalConst.pokerHandTemplateList;
		
	-- end
	return nil;
end

function TemplateParser:doComplete()
	globalManager.tickManager:removeTick(self.tick,self);
	self._data = nil;
	self._parseInfos = nil;
	self._currentParseInfo = nil;
	self._quoteData.callback(self._quoteData.target);
	self._quoteData = nil;
end
