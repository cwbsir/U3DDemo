EventType = class("EventType");

function EventType:ctor()
	
	self.Scene_Update_Position = 1000;
	self.Scene_Update_Rotation = 1001;

	self.Scene_MapInfo_Complete = 2001;

	self.Battle_Obj_Add = 2101;
	self.Battle_Obj_Remove = 2101;
end	