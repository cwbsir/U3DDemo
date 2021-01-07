SystemDateInfo = class("SystemDateInfo");


function SystemDateInfo:ctor()
	--时区
	self.timeZone = 0;
	--时区附加秒数s
	self.timeZoneSecond = 0;
	--服务器时间number
	self._serverDateTime = 0;
	--客户端时间number(毫秒)
	self._clientDateTime = 0;
	--游戏开始记录时间
	self._startTime = 0;
	
	self.secondsOfDay = 86400;
	self.millSecOfDay = 86400000;
	self.FIVE_CLOCK_TIME = 18000;--5点

	self._fixedTime = 0;
end


function SystemDateInfo:start()
	globalManager.tickManager:addTick(self.tick,self);
	if(self._startTime == 0)then
		self._startTime = os.clock() * 1000;
		self._serverDateTime = self._startTime;
	end
end

function SystemDateInfo:setTimeZone(timeZone)
	self.timeZone = timeZone;
	self.timeZoneSecond = timeZone * 3600;
end

function SystemDateInfo:tick(delta)
	--游戏已经运行的时间
	local runTime = Time.realtimeSinceStartup * 1000;
	self._clientDateTime = self._serverDateTime + (os.clock() * 1000 - self._startTime);
end


function SystemDateInfo:getSystemTime()
	return self._clientDateTime;
end

function SystemDateInfo:getSystemTimeSec()
	return math.floor(self._clientDateTime * 0.001);
end