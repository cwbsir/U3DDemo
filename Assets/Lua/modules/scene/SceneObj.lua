SceneObj = class("SceneObj");

function SceneObj:ctor()
	self.conGo = nil;
	self.conTrans = nil;
	self.collider = nil;
	self._tempVector3 = globalManager.poolManager:createVector3();
	self._namePosition = globalManager.poolManager:createVector3();
	self._info = nil;
	self._sceneController = globalManager.moduleControllers.sceneController;
	self._isStopAndHide = false;
	self._nameLabel = nil;
	self._shadow = nil;
	self._sceneInfo = self._sceneController.sceneInfo;
		
	self._parent = nil;
	self.conGo = newObject("conGo");
	self.conTrans = self.conGo.transform;
	self.collider = self.conGo:AddComponent(typeof(UnityEngine.BoxCollider));
	globalConst.layerConst:setLayer(self.conTrans,globalConst.layerConst.Actor);
	self:setBoxColliderSize();
end

function SceneObj:setBoxColliderSize()
	self._tempVector3.x = 1;
	self._tempVector3.y = 1;
	self._tempVector3.z = 1;
	local boneTrans = self:getBone("slot_billboard");
	if boneTrans ~= nil then
		self._tempVector3.y = boneTrans.localPosition.y;
		-- print("节点高度 ==============================",self._tempVector3.y);
	end
	self.collider.size = self._tempVector3;
	self._tempVector3:Set(0, self._tempVector3.y * 0.5, 0);
	self.collider.center = self._tempVector3;
	self.collider.enabled = true;
end

function SceneObj:setInfo(info)
	self._info = info;
	self:initView();
	self:initEvent();
	self:onUpdatePosition();
	self:updateNameVisible();
	self:onUpdateRotation();
	self.conGo.name = (self._info.objType .. "_" .. string.format("%d",self._info.objId));
	--print("self.conGo.name = ",self.conGo.name,self._info:getRotation():__tostring());
	local sceneData = self.conTrans:GetComponent("SceneData");
	if sceneData == nil then
		sceneData = self.conGo:AddComponent(typeof(Game.Scene.SceneData));
	end
	sceneData.objType = self._info.objType;
	sceneData.objId = self._info.objId;
	
	self:initShadow();
end


function SceneObj:initView()

end

-- function SceneObj:initShadow()
-- 	if self:showShadow() == true then
-- 		if self._shadow == nil then
-- 			self._shadow = globalManager.effectManager:create(globalConst.figureType.shadow);
-- 			self._shadow:setLayer(globalConst.layerConst.Actor);
-- 			--print("影子 === ",globalConst.figureType.shadow,self._shadow);
-- 			if self._shadow ~= nil then
-- 				self._shadow:play();
-- 				self._shadow:setParent(self.conTrans);
-- 				self._tempVector3:Set(0,0.1,0);
-- 				self._shadow:setPosition(self._tempVector3);
-- 			end
-- 		end
-- 	end
-- end

function SceneObj:showShadow()
	return true;
end

function SceneObj:initEvent()
	if self._info ~= nil then
		self._info:addEventListener(globalConst.eventType.Scene_Update_Position, self.onUpdatePosition, self);
		self._info:addEventListener(globalConst.eventType.Scene_Update_Rotation, self.onUpdateRotation, self);
	end
end

function SceneObj:removeEvent()
	if self._info ~= nil then
		self._info:removeEventListener(globalConst.eventType.Scene_Update_Position, self.onUpdatePosition, self);
		self._info:removeEventListener(globalConst.eventType.Scene_Update_Rotation, self.onUpdateRotation, self);
	end
end

function SceneObj:updateNameVisible()
	if self:showName() then
		if self._nameLabel == nil then
			self._nameLabel = self:createNameLabel();
		end
		self._nameLabel:show();
	else
		if self._nameLabel ~= nil then
			self._nameLabel:hide();
		end
	end
end

function SceneObj:showName()
	return self._info:canShowName();
end

function SceneObj:createNameLabel()
	return BaseNameLabel:new(self);
end

function SceneObj:onUpdatePosition()
	self.conTrans.localPosition = self._info:getPosition();
	if self._nameLabel ~= nil then
		self._nameLabel:updatePosition();
	end
end

function SceneObj:onUpdateRotation()
	--只转形象，不转容器，容器其他物体不需要转角度
	-- self.conTrans.localEulerAngles = self._info:getRotation();
end

function SceneObj:getObjInfo()
	return self._info;
end

function SceneObj:getPosition()
	return self._info:getPosition();
end

function SceneObj:getRotation()
	return self._info:getRotation();
end

function SceneObj:getScale()

end

function SceneObj:doMouseClick()
end

function SceneObj:responseMouse()
	return self._info:canBeSelect();
end

function SceneObj:show()
	self:setActive(true);
	
end

function SceneObj:hide()
	self:setActive(false);
end

function SceneObj:isShow()
	if self.conGo ~= nil then
		return self.conGo.activeSelf;
	end
	return false;
end

function SceneObj:setActive(value)
	if self.conGo ~= nil then
		if value then
			if self._parent ~= nil then
				globalConst.layerConst:setLayer(self.conTrans,self._parent.gameObject.layer,true);
			end
			self:updateNameVisible();
			if self._shadow ~= nil then
				self._shadow:setActive(true);
			end
		else
			globalConst.layerConst:setLayer(self.conTrans,globalConst.layerConst.ActorHide,true);
			if self._nameLabel ~= nil then
				self._nameLabel:hide();
			end
			if self._shadow ~= nil then
				self._shadow:setActive(false);
			end
		end
	end
end

function SceneObj:stopAndHide()
	if self.conGo ~= nil then
		self:setActive(false);
	end
	self:removeEvent();
	if self._nameLabel ~= nil then
		self._nameLabel:hide();
	end
	self._isStopAndHide = true;
end

function SceneObj:setParent(parentTransform)
	if(self.conTrans == nil or parentTransform == nil)then return; end
	self._parent = parentTransform;
	globalConst.layerConst:setLayer(self.conTrans,self._parent.gameObject.layer,true);
	self.conTrans:SetParent(parentTransform,false);
end

--stopAndHide之后，重新拿出来
function SceneObj:reShow()
	self._isStopAndHide = false;
end

function SceneObj:getBone(boneName)
	return nil;
end

-- 获取偏移位置
function SceneObj:getOffsetPos(offset)
	return globalManager.commonUtils:getOffsetPos(self.conTrans,offset);
end

function SceneObj:dispose()
	if self._isStopAndHide == false then
		self:stopAndHide();
	end
	if self.conGo ~= nil then
		GameObject.Destroy(self.conGo);
		self.conGo = nil;
	end
	if self._nameLabel ~= nil then
		self._nameLabel:dispose();
		self._nameLabel = nil;
	end
	if self._shadow ~= nil then
		self._shadow:dispose();
		self._shadow = nil;
	end
	globalManager.poolManager:putVector3(self._tempVector3);
	globalManager.poolManager:putVector3(self._namePosition);
	self.collider = nil;
	self.conTrans = nil;
	self._sceneController = nil;
	self._parent = nil;
end