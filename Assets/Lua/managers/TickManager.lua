TickManager = class("TickManager");

function TickManager:ctor()
	self._ticks = {};
end 

function TickManager:containTick(cb,target,tickList)
	local len = #tickList;
	local tmp = nil;
	for i = 1,len,1 do
		tmp = tickList[i];
		if(tmp.callback == cb and tmp.target == target) then
			return i;
		end
	end
	return -1;
end

function TickManager:addTick(cb,target)
	local index = self:containTick(cb,target,self._ticks);
	if(index == -1)then
		local qd = globalManager.poolManager:createQuoteData();
		qd:init(cb,target);
		qd.flag = 1;
		table.insert(self._ticks,qd);
	else
		self._ticks[index].flag = 1;
	end
end
function TickManager:removeTick(cb,target)
	local index = self:containTick(cb,target,self._ticks);
	if(index > 0)then
		self._ticks[index].flag = 0;
	end
end

function TickManager:update(deltaTime)

	self:doUpdate(self._ticks,deltaTime);
end

function TickManager:doUpdate(list,deltaTime)
	local len = #list;

	for i = len,1,-1 do
		fd = list[i];
		if fd ~= nil then
			if fd.flag == 0 then
				fd:dispose();
				table.remove(list,i);
			else
				fd.callback(fd.target,deltaTime);
			end
		end
	end

end

function TickManager:restart()
	-- self.__isRestart = true;
	self._ticks = {};
end