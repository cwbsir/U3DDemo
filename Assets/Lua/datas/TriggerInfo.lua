-- 部署数据结构
TriggerInfo = class("TriggerInfo");

function TriggerInfo:ctor()
	self.params = {};
	self.type = 0;--大类型 对应
	self.action = 0;--动作类型
	self.group = 0;--组类型
	self.descript = "";--描述
end

-- 根据数据初始化
function TriggerInfo:init(data)
	self.type = data:readByte();
	self.action = data:readShort();
	self.group = data:readByte();
	self.descript = data:readString();
	self.params = {};
	for i=1,4 do
		table.insert(self.params, data:readInt());
	end
end

-- 根据字符串初始化
function TriggerInfo:initWithString(str)
	local list = string.split(str,"$");
	if #list < 8 then
		print("TriggerInfo param error11111111111:"..str);
		return;
	end
	self.type = tonumber(list[1]);
	self.action = tonumber(list[2]);
	self.group = tonumber(list[3]);
	self.descript = tostring(list[4]);
	self.params = {};
	table.insert(self.params, tonumber(list[5]));
	table.insert(self.params, tonumber(list[6]));
	table.insert(self.params, tonumber(list[7]));
	table.insert(self.params, tonumber(list[8]));
end