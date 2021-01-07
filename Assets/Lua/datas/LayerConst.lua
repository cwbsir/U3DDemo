LayerConst = class("LayerConst");

function LayerConst:ctor()
	self.Default = LayerMask.NameToLayer("Default");
	self.TransparentFX = LayerMask.NameToLayer("TransparentFX");
	self.IgnoreRaycast = LayerMask.NameToLayer("Ignore Raycast");
	self.Water = LayerMask.NameToLayer("Water");
	self.UI = LayerMask.NameToLayer("UI");

	self.DefaultMask = bit.lshift(1, self.Default);
	self.TransparentFXMask = bit.lshift(1, self.TransparentFX);
	self.IgnoreRaycastMask = bit.lshift(1, self.IgnoreRaycast);
	self.WaterMask = bit.lshift(1, self.Water);
	self.UIMask = bit.lshift(1, self.UI);
end