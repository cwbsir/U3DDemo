LandTemplateList = class("LandTemplateList",BaseTemplateList);


function LandTemplateList:ctor()
 	LandTemplateList.super.ctor(self);
 	self.isAllParse2 = false;
 	self.typeInfoList = {};
 	self.ONE_TYPE = 1;
 	self.TWO_TYPE = 2;
  	self.K_TYPE = 13;
 	self.BIG_JOKER_TYPE = 15;
 	self.SMALL_JOKER_TYPE = 14;

	self.BIG_CARD_ID = 54;
	self.LITTLE_CARD_ID = 53;
end

function LandTemplateList:initInfo1(info)
	info.id = 0;
	info.type = 0;
	info.dataPos = 0;
	info.isParsed = false;
end

function LandTemplateList:initInfo2(info)
	info.color = 0;
	info.size = 0;
end

function LandTemplateList:parseKey(info)
	info.id = self._templateData:readByte();
	info.type = self._templateData:readByte();
	self._list[info.id] = info;
	if self.typeInfoList[info.type] == nil then
		self.typeInfoList[info.type] = {};
	end
	table.insert(self.typeInfoList[info.type],info);
end

function LandTemplateList:parseOne2(info)
	info.color = self._templateData:readByte();
	info.size = self._templateData:readByte();
	LandTemplateList.super.parseOne2(self,info);
	-- print("LandTemplateList:parseOne2",info.color);
end

function LandTemplateList:getInfo(id)
	return self:getInfo2(self._list[id]);
end

function LandTemplateList:getSizeByType(type)
	local list = self.typeInfoList[type];
	if #list > 0 then
		local temp = self:getInfo2(list[1]);
		return temp.size;
	end
	return 0;
end