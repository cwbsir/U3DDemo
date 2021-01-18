MapController = class("MapController");

function MapController:ctor()
	self.mapth = "20040";

	globalManager.eventDispatcher:addEventListener(globalConst.eventType.Scene_MapInfo_Complete, self.onMapInfoComplete, self);
end

function MapController:onMapInfoComplete(path)
	self.mapth = path;
	local mapABName = string.format("%s.unity.u",path); 
	globalManager.loaderManager:loadAB(mapABName, nil, self.onLoadMapComplete, self);
end

function MapController:onLoadMapComplete()
	StartCoroutine(function() self:loadScene(); end);
end

function MapController:loadScene()
	local scene = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(self.mapth);
	Yield(scene);
	globalManager.eventDispatcher:dispatchEvent(globalConst.eventType.Battle_Obj_Add);
end

function MapController:clearAll()

end