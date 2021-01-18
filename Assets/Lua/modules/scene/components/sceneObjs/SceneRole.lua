SceneRole = class("SceneRole",SceneObj);

function SceneRole:ctor()
	SceneRole.super.ctor(self);
	self.character = nil;
end

function SceneRole:createNameLabel()
	return RoleNameLabel:new(self);
end

function SceneRole:setInfo(info)
	SceneRole.super.setInfo(self,info);
	self:initCharacter();
end

function SceneRole:initCharacter()
	self:updateCharacter();
	self:setCharacterParent();
	self:onUpdateRotation();
end

function SceneRole:setCharacterParent()
	if self.character ~= nil then
		self.character:setParent(self.conTrans);
	end
end

-- 形象资源加载回调
function SceneRole:characterLoadComplete()
	if self._nameLabel ~= nil then
		self._nameLabel:charcterLoadComplete();
	end
	self:setBoxColliderSize();
end

function SceneRole:playAction(actionId)
	if self.character ~= nil then
		self.character:playAction(actionId);
	end
end

function SceneRole:getBone(boneName)
	if self.character ~= nil then
		local bone = self.character:getBone(boneName);
		return bone;
	end
	return nil;
end

function SceneRole:getScale()
	if self.character ~= nil then
		local scale = self.character:getScale();
		return scale;
	end
	return nil;
end

--gameobject命名
function SceneRole:setGameObjectName()
	if(self.character ~= nil)then
		self.character:setName(self._info.objType .. "_" .. string.format("%d",self._info.objId));
	end
end

function SceneRole:updateCharacter()
	
end

-- function SceneRole:onUpdatePosition(position)
-- 	if self.character ~= nil then
-- 		self.character:setPosition(position);
-- 	end
-- end

function SceneRole:onUpdateRotation()
	if self.character ~= nil then
		self.character:setRotation(self._info:getRotation());
	end
end

function SceneRole:getTitleLocalPos()
	local slot = self:getBone("slot_billboard");
	if slot ~= nil then
		return Vector3(slot.localPosition.x,slot.localPosition.y,slot.localPosition.z);
	end
	return Vector3(0,0,0);
end

function SceneRole:resetAction()
	
end

function SceneRole:stopAndHide()
	SceneRole.super.stopAndHide(self);
end

function SceneRole:dispose()
	SceneRole.super.dispose(self);
	if self.character ~= nil then
		self.character:dispose();
		self.character = nil;
	end
end
