GlobalData = class("GlobalData");

function GlobalData:ctor()
	self.USE_POOL = true;
	self.uiPrefabs = nil;
	self.defaultFont = nil;
	self.commonItemPrefabs = nil;

	self.systemDateInfo = SystemDateInfo:new();

end

function GlobalData:init()

end

function GlobalData:clearAllData()
	self.cardInfo:clearAllData();
	self.cardServerInfo:clearAllData();
end