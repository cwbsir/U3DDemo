ResObjActionController = class("ResObjActionController");

function ResObjActionController:ctor(resObj)
	self._resObj = resObj;
	self._go = nil;
	self._animator = nil;
	self._rideGo = nil;
	self._rideAnimator = nil;

	self._actionId = 0;
	self._moveSpeed = 0;
	self._isRiding = false;
	self._needReset = false;
	self._currentMoveSpeed = 0;
	self._updateMoveSpeed = false;
end

function ResObjActionController:start(go)
	self._go = go;
	self._animator = go:GetComponent(typeof(UnityEngine.Animator));
	-- print("动作机 =================",self._go.name,self._animator);
	if(self._actionId > 0)then
		self._animator:SetInteger("Action",self._actionId);
	end
	if(self._moveSpeed > 0)then
		self._animator:SetFloat("Speed",self._moveSpeed);
		if(self._isRiding and self._rideAnimator ~= nil)then
			self._rideAnimator:SetFloat("Speed",self._moveSpeed);
		end
	end
end

function ResObjActionController:setRide(go)
	self._rideGo = go;
	if(go == nil)then
		self._rideAnimator = nil;
	else
		self._rideAnimator = go:GetComponent(typeof(UnityEngine.Animator));
	end
	if(self._moveSpeed > 0 and self._rideAnimator ~= nil)then
		self._rideAnimator:SetFloat("Speed",self._moveSpeed);
	end
end

function ResObjActionController:playAction(actionId)
	if(self._go == nil)then return; end
	if(self._actionId == actionId)then return; end
	self._actionId = actionId;
	self._moveSpeed = 0;
	globalManager.tickManager:addTick(self.tick, self);
end

function ResObjActionController:playActionImmediately(actionId)
	if(self._go ~= nil)then
		self._animator:SetInteger("Action",actionId);
	end
end

--直接从某个时间开始播放动画(time范围0-1)
function ResObjActionController:playActionEnd(actionName)
	self._animator:Play(actionName, 0, 1);
end

--其实就是设置动作：0-站立  5-跑步
function ResObjActionController:setMoveSpeed(speed)
	if self._moveSpeed == speed then return; end
	self._moveSpeed = speed;
	--走路打断采集的时候，如果这里动作id赋值为0，会顶替站立动作
	-- self._actionId = 0;
	if self._go == nil then return end;
	self._updateMoveSpeed = true;
	globalManager.tickManager:addTick(self.runTick, self);
end

function ResObjActionController:setRiding(isRiding)
	if self._go == nil then return ;end;
	if(self._isRiding == isRiding)then return; end
	self._isRiding = isRiding;
	self._animator:SetBool("OnRiding",self._isRiding);
end

function ResObjActionController:runTick()
	if(self._go == nil)then return; end
	if self._animator == nil then return ;end;
	if(self._animator:IsInTransition(0))then return; end
	if self._updateMoveSpeed == true then
		if math.abs(self._currentMoveSpeed - self._moveSpeed) > 0.3 then
			self._currentMoveSpeed = Mathf.Lerp(self._currentMoveSpeed, self._moveSpeed, 0.4);
		else
			self._currentMoveSpeed = self._moveSpeed;
			self._updateMoveSpeed = false;
		end
		self._animator:SetFloat("Speed",self._currentMoveSpeed);
		if(self._isRiding and self._rideAnimator ~= nil)then
			self._rideAnimator:SetFloat("Speed",self._currentMoveSpeed);
		end
	end
	if not self._updateMoveSpeed then
		globalManager.tickManager:removeTick(self.runTick, self);
	end
end

function ResObjActionController:tick()
	if(self._go == nil)then return; end
	if self._animator == nil then return ;end;
	if(self._animator:IsInTransition(0))then return; end
	if(self._actionId ~= 0)then
		-- print("动作id == ",self._actionId);
    	self:playActionImmediately(self._actionId);

    	self._actionId = 0;
    	self._needReset = true;
    elseif(self._needReset)then
    	self:playActionImmediately(0);
    	self._needReset = false;
    	globalManager.tickManager:removeTick(self.tick, self);
    else
    	print("######################设置形象动作有问题，出现空帧！");
    end
end

-- function ResObjActionController:getStateInfo()
-- 	if(self._go == nil)then return true; end
-- 	if(self._animator == nil)then return true; end
-- 	local stateInfo = self._animator:GetCurrentAnimatorStateInfo(0);

-- 	for k,v in pairs(self._stateInfoList) do
-- 		if v:IsName("attack_01") == true then
-- 			print("equals",v == stateInfo);
-- 		end
-- 	end

-- 	for i = 1,#self._attackNames do
-- 		local name = self._attackNames[i];
-- 		if stateInfo:IsName("attack_01") == true then
-- 			self._stateInfoList[name] = stateInfo;
-- 		end
-- 	end

--     -- local stateMachine = animatorController.layers[1].stateMachine;
--     -- local animatorState = {};
--     -- print("stateMachine.states.Length",stateMachine.states.Length);
--     -- for i = 0,stateMachine.states.Length - 1 do
--     -- 	print(stateMachine.states[i+1].state.name);
--     -- end

-- 	-- print(stateInfo:IsName("attack_01"));
-- 	-- print(stateInfo.name);
-- 	return stateInfo:IsName("attack_01") ;
-- end

--是否攻击中  返回true，则不可切走路
-- function ResObjActionController:isDoingAttack()
-- 	if(self._go == nil)then return true; end
-- 	if(self._animator == nil)then return true; end

-- 	local stateInfo = self._animator:GetCurrentAnimatorStateInfo(0);
-- 	return arrayIndexOf(self._attackNameHashs,stateInfo.shortNameHash) >= 0;
-- end

	-- roac._attackNameHashs = {UnityEngine.Animator.StringToHash("attack_01"),UnityEngine.Animator.StringToHash("attack_02"),UnityEngine.Animator.StringToHash("attack_03"),UnityEngine.Animator.StringToHash("attack_04"),UnityEngine.Animator.StringToHash("attack_05"),UnityEngine.Animator.StringToHash("attack_06")};

-- 动作是否结束
-- function ResObjActionController:isOver()
-- 	if(self._go == nil)then return true; end
-- 	if(self._animator == nil)then return true; end

-- 	local stateInfo = self._animator:GetCurrentAnimatorStateInfo(0);
-- 	if info.normalizedTime >= 1.0f then
-- 		return true;
-- 	end
-- 	return false; 
-- end

function ResObjActionController:getCurClipName()
	if(self._go == nil)then return true; end
	if(self._animator == nil)then return true; end

	local stateInfo = self._animator:GetCurrentAnimatorStateInfo(0);
	-- return stateInfo.shortNameHash;
	return self:hashToString(stateInfo.shortNameHash);
end


-- -- 加载额外动作片段
-- function ResObjActionController:loadAdtClip(animationClip)
-- 	if self._animator ~= nil then
-- 		local tOverrideController = UnityEngine.AnimatorOverrideController.New(self._animator.runtimeAnimatorController);
-- 		self._animator.runtimeAnimatorController = tOverrideController;
-- 		local replaceName = animationClip.name.."_replace";
-- 		tOverrideController.set_Item(tOverrideController,replaceName,animationClip);
--          self._animator.runtimeAnimatorController = nil;
--          self._animator.runtimeAnimatorController = tOverrideController;
--          -- self._animator:Play("attack_01", 0, 0);
-- 	end
-- end

-- 加载额外动作片段
function ResObjActionController:loadAdtClips(animationClips)
	if self._animator ~= nil then
		local tOverrideController = UnityEngine.AnimatorOverrideController.New(self._animator.runtimeAnimatorController);
		self._animator.runtimeAnimatorController = tOverrideController;

		local clipOverrides = AnimationClipOverrides.New(tOverrideController.overridesCount);
		tOverrideController.GetOverrides(tOverrideController,clipOverrides);

		local len = #animationClips;
		for i=1,len do
			local replaceName = animationClips[i].name.."_replace";
			clipOverrides.set_Item(clipOverrides,replaceName,animationClips[i]);
			-- print("片段名称 == ",animationClips[i].name,replaceName,clipOverrides.this[replaceName]);
		end
		tOverrideController.ApplyOverrides(tOverrideController,clipOverrides);
	end
end


function ResObjActionController:hashToString(value)
	if UnityEngine.Animator.StringToHash("attack_01") == value then
		return "attack_01";
	elseif UnityEngine.Animator.StringToHash("skill_01") == value then
		return "skill_01";
	elseif UnityEngine.Animator.StringToHash("skill_02") == value then
		return "skill_02";
	elseif UnityEngine.Animator.StringToHash("skill_03") == value then
		return "skill_03";
	elseif UnityEngine.Animator.StringToHash("fall") == value then
		return "fall";
	elseif UnityEngine.Animator.StringToHash("up") == value then
		return "up";
	elseif UnityEngine.Animator.StringToHash("die") == value then
		return "die";
	elseif UnityEngine.Animator.StringToHash("ready") == value then
		return "ready";
	end
	return "no actionName"..value;
end


function ResObjActionController:dispose()
	globalManager.tickManager:removeTick(self.tick, self);
	globalManager.tickManager:removeTick(self.runTick, self);
	self._resObj = nil;
	self._go = nil;
	self._animator = nil;
	self._rideGo = nil;
	self._rideAnimator = nil;
end