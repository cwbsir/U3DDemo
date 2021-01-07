EventDispatcher = class("EventDispatcher");

function EventDispatcher:ctor()
	self._count = 100;
	self._listeners = {};
	self._delTypeList = {};
end

function EventDispatcher:addEventListener(type,listener,target,toFirst)

	local tmp = self:getListener(type,listener,target);
	if(tmp == nil)then
		if(self._listeners[type] == nil)then
			self._listeners[type] = {};
		end
		local qd = globalManager.poolManager:createQuoteData();
		qd.flag = 1;
		qd:init(listener,target);
		if(toFirst == true)then
			table.insert(self._listeners[type],qd,1);
		else
			table.insert(self._listeners[type],qd);
		end
	else
		tmp.flag = 1;
	end
end

function EventDispatcher:removeEventListener(type,listener,target)
	if not self._listeners then return; end
	local list = self._listeners[type];
	if(list ~= nil)then
		local len = #list;
		local qd = nil;
		for i = 1,len,1 do
			qd = list[i];
			if(qd.target == target and qd.callback == listener)then
				qd.flag = 0;
				self._delTypeList[type] = type;
				globalManager.tickManager:addTick(self.delTick,self);
				break;
			end
		end
	end
end

function EventDispatcher:delTick(deltaTime)
	if(self._listeners ~= nil)then
		for k,v in pairs(self._delTypeList) do
			local list = self._listeners[v];
			local count = #list;
			for i = count,1,-1 do
				if(list[i].flag == 0)then
					list[i]:dispose();
					table.remove(list,i);
				end
			end
		end
	end
	self._delTypeList = {};
	globalManager.tickManager:removeTick(self.delTick,self);
end


function EventDispatcher:getListener(type,listener,target)
	local list = self._listeners[type];
	if(list ~= nil)then
		local len = #list;
		local qd = nil;
		for i = 1,len,1 do
			qd = list[i];
			if(qd.callback == listener and qd.target == target)then
				return qd;
			end
		end
	end
	return nil;
end

function EventDispatcher:hasListener(type,listener,target)
	local list = self._listeners[type];
	if(list ~= nil)then
		local len = #list;
		local qd = nil;
		for i = 1,len,1 do
			qd = list[i];
			if(qd.callback == listener and qd.target == target)then
				return i;
			end
		end
	end
	return -1;
end

function EventDispatcher:dispatchEvent(evtType,evtData)
	local list = self._listeners[evtType];
	if(list ~= nil)then
		local len = #list;
		for i = len,1,-1 do
			local qd = list[i];
			if(qd.flag == 1)then
				if(qd.callback ~= nil)then
					qd.callback(qd.target,evtData);
					--TODO try catch
				end
			end
		end
	end
end

function EventDispatcher:dispose()
	globalManager.tickManager:removeTick(self.delTick,self);
	self._listeners = nil;
	self._delTypeList = nil;
end
