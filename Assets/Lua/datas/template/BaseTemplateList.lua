BaseTemplateList = class("BaseTemplateList");

function BaseTemplateList:ctor()
	self._templateData = nil;--该模板表二进制数据，全部解析完成则清除
	self.dataLength = 0;--数据字节长度
	self.isAllParse2 = false;--是否在粗略解析后立即进行详细解析
	self.parseComplete1 = false;--粗略解析结束标记
	self._itemCount = 0;--Info数量
	self._parseItemCount1 = 0;--已粗略解析Info数量
	self._parseItemCount2 = 0;--已详细解析Info数量
	self._list = nil;--Info存储字典（可能是多维）
end

function BaseTemplateList:init(data,length)
	self._list = {};
	self._templateData = data;
	self.dataLength = length;
	self._itemCount = data:readInt();
	self._parseItemCount1 = 0;
	if(self._itemCount == 0)then
		self.parseComplete1 = true;
	end
end

--给Info添加粗略解析必需属性
function BaseTemplateList:initInfo1(info)
	info.id = 0;
	info.dataPos = 0;
	info.isParsed = false;
end

--给Info添加除必需属性之外的所有属性
function BaseTemplateList:initInfo2(info)

end

--开始解析模板表
function BaseTemplateList:parse()
	local len = self:parsePerFrame1();
	for i = 1,len,1 do
		self:parseOne1();
		self._parseItemCount1 = self._parseItemCount1 + 1;
		if(self._parseItemCount1 >= self._itemCount)then
			self.parseComplete1 = true;
			break;
		end
	end
end

--每帧解析Info数量
function BaseTemplateList:parsePerFrame1()
	return self._itemCount;
end

--粗略解析一个Info（根据self.isAllParse2参数决定是否马上进行详细解析）
function BaseTemplateList:parseOne1()
	local info = {};
	self:initInfo1(info);
	self:parseKey(info);
	local len = self._templateData:readUShort();
	info.dataPos = self._templateData:getPosition();
	if(self.isAllParse2)then
		self:initInfo2(info);
		self._templateData:setPosition(info.dataPos);
		self:parseOne2(info);
	else
		self._templateData:setPosition(info.dataPos + len);
	end
end

--粗略解析中的解析主键部分（多主键或非"id"主键需重写）
function BaseTemplateList:parseKey(info)
	info.id = self._templateData:readInt();
	self._list[info.id] = info;
end

--详细解析一个Info（不同List对应不同解析结构）
function BaseTemplateList:parseOne2(info)
	info.isParsed = true;
	self._parseItemCount2 = self._parseItemCount2 + 1;
	if(self._parseItemCount2 >= self._itemCount)then
		self._templateData:reSet();
		self._templateData = nil;
	end
end

--若当前Info未详细解析，则进行详细解析后返回
function BaseTemplateList:getInfo2(info)
	if(info ~= nil and info.isParsed == false)then
		self:initInfo2(info);
		self._templateData:setPosition(info.dataPos);
		self:parseOne2(info);
	end
	return info;
end

function BaseTemplateList:getCurReadPos()
	--如果已经全部读取完成，则返回最大值使得下一个模板表延迟一帧解析
	if(self._templateData == nil)then return 99999; end
	return self._templateData:getPosition();
end