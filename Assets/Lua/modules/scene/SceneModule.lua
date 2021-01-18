SceneModule = class("SceneModule");

function SceneModule:ctor()
	self.mapController = MapController:new();
	self.sceneObjController = SceneObjController:new();
end