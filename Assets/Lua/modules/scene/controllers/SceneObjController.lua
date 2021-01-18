SceneObjController = class("SceneObjController");

function SceneObjController:ctor()
	self._objList = {};
	-- self._playerList = {};

	self:initEvent();
end

function SceneObjController:initEvent()
	globalManager.eventDispatcher:addEventListener(globalConst.eventType.Battle_Obj_Add, self.onAddObj, self);
	globalManager.eventDispatcher:addEventListener(globalConst.eventType.Battle_Obj_Remove, self.onRemoveObj, self);
end


function SceneObjController:onAddObj(info)
	local resObj = BaseResObj:new("role$6208.u","6208");
	resObj:start(self.loadComplete,self);
	resObj:setMoveSpeed(5);
	resObj:setPosition(65,-110,15);

	-- if self._objList[info.objId] ~= nil then return; end
	-- local battleObj = info.__obj;
	-- if(battleObj == nil)then
	-- 	if info:isHero() then
	-- 		battleObj = BattleHero:new();
	-- 	elseif info:isZhenfa() then
	-- 		battleObj = BattleZhenfa:new();
	-- 	end
	-- 	info.__obj = battleObj;
	-- end
	-- -- print("场景添加玩家形象 = ",info.objId);
	-- battleObj:setInfo(info);
	-- self._objList[info.objId] = battleObj;
end

function SceneObjController:loadComplete()
	local tmpVector3 = Vector3.zero;
	tmpVector3:Set(65,-110,15);
	globalManager.cameraManager:setFocus(tmpVector3);
end

function SceneObjController:onRemoveObj(id)
	-- local battleObj = self._objList[id];
	-- if battleObj ~= nil then
	-- 	self._objList[id] = nil;
	-- 	battleObj:reset();
	-- end
end

function SceneObjController:getObj(id)
	return self._objList[id];
end

function SceneObjController:getObjList()
	return self._objList;
end

function SceneObjController:clearAll()

end