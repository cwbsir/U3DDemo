-- 部署脚本管理器
TriggerManager = class("TriggerManager");

function TriggerManager:ctor()
	self._handlerList = {};
	-- 弹窗器
	-- local handler = PopTriggerHandler:new();
	-- self._handlerList[handler.type] = handler;

	-- -- 事件部署
	-- handler = EventTriggerHandler:new();
	-- self._handlerList[handler.type] = handler;
end

-- 执行单个部署脚本
function TriggerManager:doHandler(info,param)
	if info == nil then return;end
	local trigger = self._handlerList[info.type];
	if trigger ~= nil then
		trigger:handler(info,param);
	end
end