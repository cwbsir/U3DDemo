QuoteData = class("QuoteData");

function QuoteData:ctor()
	self.flag = 0;
	self.target = nil;
	self.callback = nil;
	self.assetName = nil;--用于LoaderItemIII加载回调找出对应asset名称，不想反复给params创建{}
	self.params = nil;
	self.__isInPoolList = false;
	self.__isForPoolList = false;
	self.hasCall = false;
end

function QuoteData:init(callback,target)
	self.callback = callback;
	self.target = target;
end

function QuoteData:isSame(cb,target)
	return self.callback == cb and self.target == target;
end


function QuoteData:poolDispose()
	self:doClear();
end

function QuoteData:doClear()
	self.callback = nil;
	self.target = nil;
	self.assetName = nil;
	self.params = nil;
	self.hasCall = false;
end

function QuoteData:dispose()
	globalManager.poolManager:putQuoteData(self);
end
