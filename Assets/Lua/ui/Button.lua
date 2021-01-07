Button = class("Button",Image);

function Button:ctor()
	self._clickScale = nil;
	self._constantX = 1;
	self._constantY = 1;
	Button.super.ctor(self);
end

function Button:setObject(gameObject)
	Button.super.setObject(self,gameObject);
	self:setTouchEnabled(true);
	self:setClickScale(true);
end

--设置方向传1或-1
function Button:setConstant(x,y)
	-- body
	self._constantX = x;
	self._constantY = y;
end

-- value true 缩放 false不缩放
function Button:setClickScale(value)
	self._clickScale = value;
end

function Button:downHandler(self,param1,param2)
	if self._clickScale then
		self:setScale(1.1*self._constantX,1.1*self._constantY);
	end
	Button.super.downHandler(self,self,param1,param2);
end

function Button:upHandler(self,param1,param2)
	if self._clickScale then
		self:setScale(1*self._constantX,1*self._constantY);
	end	
	Button.super.upHandler(self,self,param1,param2);
end
