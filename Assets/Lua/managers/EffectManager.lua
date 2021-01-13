-- 特效创建器
EffectManager = class("EffectManager");

function EffectManager:ctor()
	self._tempVector3 = nil;
end

function EffectManager:create(figureId,clearType,isUI,isQuoteFirst,isLoadAdtAnim)
	local figureTmp = globalConst.figureTemplate:getInfo(figureId);
	if figureTmp == nil then
		print("！！！！模板没有此形象数据！！！！",figureId);
		return nil;
	end
	if figureTmp.type == 3 then
		-- 帧动画
		return self:createUIEffect(figureId,clearType);
	end
	local resInfo = ResObjInfo:new();
	resInfo:setStyleId(figureId);
	local effect = nil;
	if figureTmp.type == 1 then
		-- 普通特效
		effect = BaseEffect:new(resInfo,clearType,isUI,isQuoteFirst);
	elseif figureTmp.type == 2 then
		-- 子弹特效
		effect = SkillBulletActionNew:new(resInfo,clearType);
	else
		-- 是否需要带灯(带灯需要包多一层con)
		if isUI then
			effect = ResUISceneObj:new(resInfo,clearType,nil,isUI,nil,nil,nil,isLoadAdtAnim);
		else
			effect = ResPlayerContainer:new(resInfo,clearType,isUI);
		end
	end
	-- 因为数据在此创建，所以要自动清除
	effect:setIsDisposeInfo(true);
	return effect;
end

function EffectManager:createUIEffect(figureId,clearType)
	local resId = globalConst.figureTemplate:getResId(figureId);
	if resId == nil then
		print("！！！！模板没有此形象数据！！！！",figureId);
		return nil;
	end
	local tempResTempInfo = nil;
	if(resId ~= nil)then
		tempResTempInfo = globalConst.resTemplateList:getResInfo(resId);
		if tempResTempInfo == nil then 
			print("##########ERROR!!资源ID传入错误##########",resId);
			return nil;
		end
	end
	local effect = globalManager.kCreator:createNode("uieffect"..figureId,false);
	local _abPath = globalConst.resTemplateList:getAssetPath(tempResTempInfo);
	local _abAssetName = globalConst.resTemplateList:getAssetName(tempResTempInfo);
	print("开始记载AB。。。。。。。。",_abPath,_abAssetName);
	effect:loadNodeAbAdt(_abPath,_abAssetName);
	return effect;
end