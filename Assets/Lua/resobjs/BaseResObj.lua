-- 特效，场景形象 资源基类
BaseResObj = class("BaseResObj");

function BaseResObj:ctor(abPath,abAssetName)
	self._go = nil;
	self._transform = nil;

	self._actionController = nil;
	self._position = nil;
	self._rotation = nil;
	self._scale = nil;
	self._loadCompleteCallBack = nil;
	self._loadCompleteTarget = nil;
	
	self._layer = nil;
	self._name = nil;
	self._parent = nil;
	self._isStarted = false;--是否已加载过
	self._position = globalManager.poolManager:createVector3(0,0,0);
	self._rotation = globalManager.poolManager:createVector3(0,0,0);

	self._scale = globalManager.poolManager:createVector3(1,1,1);

	self._abPath = nil;
	self._abAssetName = nil;
end

function BaseResObj:start(callback,target)
	self._actionController = ResObjActionController:new(self);
	self._loadCompleteCallBack = callback;
	self._loadCompleteTarget = target;
	self._isStarted = true;
	self:startLoad();
end

function BaseResObj:startLoad()
	globalManager.loaderManager:loadAB(self._abPath,self._abAssetName,self.defaultModelLoadComplete,self);
end

function BaseResObj:defaultModelLoadComplete(abName,assetName,abContent,asset)
	self._go = newObject(asset);
	self._transform = self._go.transform;
	self._actionController:start(self._go);
	self:animatorLoadComplete();
end

function BaseResObj:animatorLoadComplete()
	self:setParent(self._parent);
	self:updatePosition();
	self:updateRotation();
	self:updateScale();
	self:updateLayer();
	self:updateName();
	self:loadCompleteCB();
end

function BaseResObj:loadCompleteCB()
	if(self._loadCompleteCallBack ~= nil)then
		self._loadCompleteCallBack(self._loadCompleteTarget,self);
		self._loadCompleteCallBack = nil;
		self._loadCompleteTarget = nil;
	end
end

function BaseResObj:setPosition(position,y,z)
	local x = position;
	if(y == nil or z == nil)then
		x = position.x;
		y = position.y;
		z = position.z;
	end
	if(self._position ~= nil and self._position.x == x and self._position.y == y and self._position.z == z)then return; end
	self._position.x = x;
	self._position.y = y;
	self._position.z = z;
	self:updatePosition();
end
function BaseResObj:setRotation(rotation,y,z)
	local x = rotation;
	if(y == nil or z == nil)then
		x = rotation.x;
		y = rotation.y;
		z = rotation.z;
	end
	if(self._rotation ~= nil and self._rotation.x == x and self._rotation.y == y and self._rotation.z == z)then return; end
	self._rotation.x = x;
	self._rotation.y = y;
	self._rotation.z = z;
	self:updateRotation();
end
function BaseResObj:setScale(scale,y,z)
	local x = scale;
	if(y == nil or z == nil)then
		x = scale.x;
		y = scale.y;
		z = scale.z;
	end
	if(self._scale ~= nil and self._scale.x == x and self._scale.y == y and self._scale.z == z)then return; end
	self._scale.x = x;
	self._scale.y = y;
	self._scale.z = z;
	self:updateScale();
end

function BaseResObj:updatePosition()
	if(self._transform ~= nil)then
		self._transform.localPosition = self._position;
	end
end
function BaseResObj:updateRotation()
	if(self._transform ~= nil)then
		self._transform.localEulerAngles = self._rotation;
	end
end
function BaseResObj:updateScale()
	if(self._transform ~= nil)then
		self._transform.localScale = self._scale;
	end
end

function BaseResObj:getPosition()
	return self._position;
end
function BaseResObj:getRotation()
	return self._rotation;
end
function BaseResObj:getScale()
	return self._scale;
end

function BaseResObj:isShow()
	if self._go ~= nil then
		return self._go.activeSelf;
	end
	return false;
end

function BaseResObj:playAction(action)
	if(self._actionController == nil)then return; end
	self._actionController:playAction(action);
end
function BaseResObj:playActionImmediately(action)
	if(self._actionController == nil)then return; end
	self._actionController:playActionImmediately(action);
end
function BaseResObj:playActionEnd(actionName)
	if(self._actionController == nil)then return; end
	self._actionController:playActionEnd(actionName);
end
function BaseResObj:setMoveSpeed(speed)
	if(self._actionController == nil)then return; end
	self._actionController:setMoveSpeed(speed);
end
function BaseResObj:resetToReady()
	if(self._actionController == nil)then return; end
	self._actionController:resetToReady();
end
function BaseResObj:stopAnimator()
	if(self._actionController == nil)then return; end
	self._actionController:stop();
end
function BaseResObj:restartAnimator()
	if(self._actionController == nil)then return; end
	self._actionController:restart();
end

--获取当前动作状态片段名称
function BaseResObj:getCurActionName()
	return self._actionController:getCurClipName();
end

function BaseResObj:setParent(trans)
	if trans == nil then return;end
	self._parent = trans;
	-- Equals 防止go被释放了，引用还在的情况
	if not isNil(self._transform) and not isNil(self._parent.gameObject) then
		self._transform:SetParent(self._parent,false);
	end
end

function BaseResObj:show()
	self:setActive(true);
end

function BaseResObj:hide()
	self:setActive(false);
end

function BaseResObj:setActive(value)
	if self._go ~= nil then
		-- if value then
		-- 	if self._layer ~= nil and self._parent ~= nil then
		-- 		globalConst.layerConst:setLayer(self._transform,self._layer,true);
		-- 	elseif self._parent ~= nil then
		-- 		globalConst.layerConst:setLayer(self._transform,self._parent.gameObject.layer,true);
		-- 	end
		-- else
		-- 	globalConst.layerConst:setLayer(self._transform,globalConst.layerConst.ActorHide,true);
		-- end
	end
end

-- function BaseResObj:setLayer(layer)
-- 	if self._layer == layer then return end;
-- 	self._layer = layer;
-- 	self:updateLayer();
-- end

-- function BaseResObj:updateLayer()
-- 	if self._transform == nil or self._layer == nil then return end;
-- 	globalConst.layerConst:setLayer(self._transform,self._layer,true);
-- end

function BaseResObj:setName(name)
	if self._name == name then return end;
	self._name = name;
	self:updateName();
end

function BaseResObj:updateName()
	if self._go == nil or self._name == nil then return end;
	self._go.name = self._name;
end

function BaseResObj:getBone(boneName)
	return nil;
end

function BaseResObj:setIsDisposeInfo(value)
	self._isAutoDispose = value;
end

function BaseResObj:getInfoTemp()
	return self._infoTemp;
end

function BaseResObj:playTest()
	self:playAction(33);
	-- self:loadAdtAnimClips();
	-- if self._actionController ~= nil then
	-- 	self._actionController:playTestClip();
	-- end
end

function BaseResObj:isInTransition()
	if self._actionController == nil then return true end;
	return self._actionController:isInTransition();
end

function BaseResObj:getTransform()
	return self._transform;
end

function BaseResObj:poolReset()
	self:stopAnimator();
	self._loadCompleteCallBack = nil;
	self._loadCompleteTarget = nil;
	self._isQuoteFirst = nil;
	self._isAutoDispose = false;
	self._layer = nil;
end

function BaseResObj:dispose()
	if(self._actionController ~= nil)then
		self._actionController:dispose();
		self._actionController = nil;
	end
	if(self._abPath ~= nil and self._abAssetName ~= nil)then
		globalManager.loaderManager:removeAB(self._abPath,self.defaultModelLoadComplete,self,self._abAssetName);
		self._abPath = nil;
		self._abAssetName = nil;

	end
	if(isNil(self._go) == false)then
		destroy(self._go);
		self._go = nil;
	end
	self._transform = nil;
	if(self._position ~= nil)then
		globalManager.poolManager:putVector3(self._position);
		self._position = nil;
	end
	if(self._rotation ~= nil)then
		globalManager.poolManager:putVector3(self._rotation);
		self._rotation = nil;
	end
	if(self._scale ~= nil)then
		globalManager.poolManager:putVector3(self._scale);
		self._scale = nil;
	end
	self._loadCompleteCallBack = nil;
	self._loadCompleteTarget = nil;
	self._layer = nil;
	self._name = nil;
	self._parent = nil;
end