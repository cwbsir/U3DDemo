ScrollView = class("ScrollView",Node);

function ScrollView:ctor()
	self._viewRect = nil;--滚动可视窗口(=遮罩大小)
	self._container = nil;--装视图的容器
	self._scrollRect = nil;
	self._contentSize = nil;
	self._viewPortSize = nil;
	self._uiScrollContent = nil;
	self._itemWidth = 40;--itemview宽
	self._itemHeight = 40;--itemview高
	self._padding = {top = 0, right = 0, bottom = 0, left = 0};--边距
	self._gap = {gapW = 0, gapH = 0};--格子间隙
	self._rcCount = 1;--每行或每列 几个格子
	self._perFrameCount = 12;--每帧创建几个格子(分帧处理)
	self._itemList = {};--list数组(itemview)
	self._waittingList = {};--等待队列
	self._getItemFunc = nil;--创建itemview回调函数
	self._getIdFunc = nil;--创建list数组下标回调函数(key值)
	self._getItemLenFunc = nil;--获取itemInfoList长度回调函数
	self._cbTarget = nil;--回调target
	self._allCount = 0;--格子总数(计算位置用)
	self._idexIsSetPos = {};--记录下标是否设置了位置

	self._lastStartIndex = 0;--记录上一次开始下标
	self._lastEndIndex = 0;--记录上一次结束下标
	self._hasSetFormat = false;--是否已调用setformat
	self._listParentNode = nil;--列表的父节点
	ScrollView.super.ctor(self);
end

function ScrollView:createComponent()
	self._container = self.go.transform:Find("Viewport/Content");
	self._scrollRect = self.go:GetComponent(typeof(UnityEngine.UI.ScrollRect));

	local scrollContents = self.go:GetComponentsInChildren(typeof(UIScrollContent),true);
	if scrollContents ~= nil and scrollContents.Length > 0 then
		self._uiScrollContent = scrollContents[0];
			-- 滚动触发函数
		self._uiScrollContent.onPositionChange = function() self:refresh(false) end
	end

	local masks = self.go:GetComponentsInChildren(typeof(UnityEngine.UI.Mask), true);
	if masks ~= nil and masks.Length > 0 then
		self._viewRect = masks[0].transform;
	end
	self:setVertical(true);


end

-- 设置边距
function ScrollView:setPadding(top, right, bottom, left)
    self._padding.top = top or 0;
    self._padding.right = right or 0;
    self._padding.bottom = bottom or 0;
    self._padding.left = left or 0;
    self:refresh();
end

-- 设置行列间距
function ScrollView:setGap(gapW, gapH)
	self._gap.gapW = gapW or 0;
	self._gap.gapH = gapH or 0;
	self:refresh();
end

-- 滚到顶部
function ScrollView:scrollToTop()
    self:stopMovement();
    self._container.anchoredPosition = Vector2.zero;
end

-- 滚到底部
function ScrollView:scrollToBottom()
    self:stopMovement();
    local jumpPos = Vector2.zero;
    if self._scrollRect.horizontal then
    	jumpPos.x = -(self._container.rect.width - self._viewRect.rect.width);
    end
    
    if self._scrollRect.vertical then
    	jumpPos.y = self._container.rect.height - self._viewRect.rect.height;
    end
    self._container.anchoredPosition = jumpPos;
end

-- 跳到某个位置 x:0~1,y:0~1  0,0左下角
function ScrollView:jumpToPos(posX,posY)
	self:stopMovement();
    local jumpPos = Vector2.zero;
	jumpPos.x = posX or 0;
	jumpPos.y = posY or 0;
    self._container.anchoredPosition = jumpPos;
end

function ScrollView:stopMovement()
    if(self._scrollRect ~= nil)then
        self._scrollRect:StopMovement();
    end
end

function ScrollView:forbidScoll()
	self._scrollRect.vertical = false;
	self._scrollRect.horizontal = false;
end

function ScrollView:setHorizontal(value)
	self._scrollRect.horizontal = value;
	self._scrollRect.vertical = not value;
end
function ScrollView:setVertical(value)
	self._scrollRect.vertical = value;
	self._scrollRect.horizontal = not value;
end

-- 回调创建item函数
function ScrollView:setCallBacks(getItemFunc,getIdFunc,getLenFunc,cbTarget)
	self._getItemFunc = getItemFunc;
	self._getIdFunc = getIdFunc;
	self._getItemLenFunc = getLenFunc;
	self._cbTarget = cbTarget;
end

-- 启动函数(必须) rcCount 行或列格子数 item宽 item高 percount每帧创建几个
function ScrollView:setFormat(rcCount,itemW,itemH,perCount)
	if rcCount ~= nil and rcCount > 0 then self._rcCount = rcCount; end
	if itemW ~= nil and itemW > 0 then self._itemWidth = itemW; end
	if itemH ~= nil and itemH > 0 then self._itemHeight = itemH; end
	if perCount ~= nil and perCount > 0 then self._perFrameCount = perCount; end
	self._hasSetFormat = true;
	self:refresh();
end

-- force true false 强制刷新(不滚动情况下,操作格子需要刷新)
function ScrollView:refresh(force)
	if self._getIdFunc == nil or self._getItemFunc == nil 
		or self._getItemLenFunc == nil or not self._hasSetFormat then return; end
	if force == nil then force = true; end
	if force then
		self._lastStartIndex = 0;
		self._lastEndIndex = 0;
		self._idexIsSetPos = {};
		self._allCount = self._getItemLenFunc(self._cbTarget);
		self:updateContentSize();
	end
	self:updateWaittingList(force);
	-- 没有等待列表是返回
	if #self._waittingList <= 0 then return; end
	globalManager.tickManager:addTick(self.mainTick,self);
end

-- 计算需要创建的item列表（只存位置）
function ScrollView:updateWaittingList(force)
	if force == nil then force = true; end
	local curPos = self._container.anchoredPosition;
	local startIndex = 0;
	local endIndex = 0;
	local contentW = self:getContentSize().x;
	local contentH = self:getContentSize().y;
	local viewW = self._viewRect.sizeDelta.x;
	local viewH = self._viewRect.sizeDelta.y;

	-- 开始结束第几个格子索引
	startIndex = math.floor((curPos.y - self._padding.top) / (self._itemHeight + self._gap.gapW)) * self._rcCount;
	startIndex = math.max(startIndex,1);
	endIndex = (math.ceil(viewH / (self._itemHeight + self._gap.gapH))+1) * self._rcCount + startIndex;
	endIndex = math.min(endIndex,self._allCount + 1);
	print("计算格子索引 == ",startIndex,endIndex,curPos.y);
	-- 只挪动几像素index不变，不往下执行
	if self._lastStartIndex == startIndex and self._lastEndIndex == endIndex then return;end

	self._lastStartIndex = startIndex;
	self._lastEndIndex = endIndex;

	-- 计算需要显示的位置列表
	self._waittingList = {};
	for i=1,self._allCount do
		local item = self:getItemByIndex(i);
		if i >= startIndex and i <= endIndex then
			if item ~= nil then 
				if force or not self._idexIsSetPos[i] then 
					self:setItemPos(i,item);
					self._idexIsSetPos[i] = true; 
				end
				item:show();
			else
				table.insert(self._waittingList,i);
			end
		else
			if item ~= nil then
				item:hide();
			end
		end
	end
end

function ScrollView:getItemByIndex(index)
	local id = self._getIdFunc(self._cbTarget,index);
	return self:getItemById(id);
end

function ScrollView:getItemById(id)
	return self._itemList[id];
end

function ScrollView:setItemPos(index,item)
	local x = ((index - 1) % self._rcCount) * (self._itemWidth + self._gap.gapW) + self._padding.left;
	local y = math.floor((index - 1) / self._rcCount) * (self._itemHeight + self._gap.gapH) + self._padding.top;
	-- print("设置位置 == ",index,x,y,self._padding.left,self._padding.top);
	item:setPosition(x,-y,true,true);
end

function ScrollView:mainTick()
	-- 没有等待列表时返回
	if #self._waittingList <= 0 then 
		globalManager.tickManager:removeTick(self.mainTick,self);
		return;
	end
	local tmpLen = math.min(#self._waittingList,self._perFrameCount);
	-- 每帧创建多少个itemView
	for i=1,tmpLen do
		local index = table.remove(self._waittingList,1);
		local item = self:createItemByIndex(index);
		if item == nil then break;end
		self:setItemPos(index,item);
		self._idexIsSetPos[index] = true;
		item:setParent(self._container);
		item:show();
	end
end

function ScrollView:createItemByIndex(index)
	local item = nil;
	if index <= self._allCount then
		local id = self._getIdFunc(self._cbTarget,index);
		item = self._itemList[id];
		if item == nil then
			item = self._getItemFunc(self._cbTarget,index);
			self._itemList[id] = item;
		end
	end
	return item;
end

function ScrollView:getItem(id)
	return self._itemList[id];
end

function ScrollView:getItems()
	return self._itemList;
end

function ScrollView:addItemFresh()
	self:refresh();
end

--调用这个需先移除对应的itemInfo
function ScrollView:removeItemById(id,needRefresh)
	local item = self._itemList[id];
	if item ~= nil then
		self._itemList[id]:hide();
		self._itemList[id]:dispose();
		self._itemList[id] = nil;
	end
	if needRefresh == nil or needRefresh then 
		self:refresh();
	end
end

function ScrollView:removeAllItem()
	if next(self._itemList) then
		for k, v in pairs(self._itemList) do
			if self._itemList[k] ~= nil then
	        	self._itemList[k]:dispose();
	        	self._itemList[k] = nil;
	        end
    	end
    	self._itemList = {};
    end
	self:scrollToTop();
end

-- 计算内容容器宽高
function ScrollView:updateContentSize()
	-- 内容高度格子数
	local countH = math.ceil(self._allCount / self._rcCount);
	local countV = self._rcCount;
	local tmpW = self._padding.left + self._padding.right + self._gap.gapW *(countV - 1) + self._itemWidth * countV;
    local tmpH = self._padding.top + self._padding.bottom + self._gap.gapH *(countH - 1) + self._itemHeight * countH;
    self:setContentSize(tmpW,tmpH);
end

function ScrollView:getContentSize()
	if(self._contentSize == nil)then
		local size = self._container.sizeDelta;
		self._contentSize = globalManager.poolManager:createVector2(size.x,size.y);
	end
	return self._contentSize;
end

-- 设置容器大小
function ScrollView:setContentSize(width,height)
	local contentSize = self:getContentSize();
	if width ~= nil then 
		contentSize.x = width;
	end
	if height ~= nil then
		contentSize.y = height;
	end
	self._container.sizeDelta = contentSize;
end

function ScrollView:getViewPortSize()
	if(self._viewPortSize == nil)then
		local size = self._viewRect.sizeDelta;
		self._viewPortSize = globalManager.poolManager:createVector2(size.x,size.y);
	end
	return self._viewPortSize;
end

-- 设置窗口大小
function ScrollView:setViewPortSize(width,height)
	local size = self:getViewPortSize();
	if width ~= nil then 
		size.x = width;
	end
	if height ~= nil then
		size.y = height;
	end
	self._viewRect.sizeDelta = size;
end

--获取容器的高
function ScrollView:getViewportHeight()
	return self._viewRect.rect.height;
end

function ScrollView:getViewportWidth()
	return self._viewRect.rect.width;
end

function ScrollView:dispose()
	globalManager.tickManager:removeTick(self.mainTick,self);
	self._viewRect = nil;
	self._scrollRect = nil;
	self._padding = nil;
	self._gap = nil;
	if next(self._itemList) then
		for k, v in pairs(self._itemList) do
			if self._itemList[k] ~= nil then
	        	self._itemList[k]:dispose();
	        	self._itemList[k] = nil;
	        end
    	end
    end
    self._itemList = nil;
    self._waittingList = nil;
    self._getItemFunc = nil;
    self._getIdFunc = nil;
    self._container = nil;
    self._getItemLenFunc = nil;
    self._cbTarget = nil;
    self._uiScrollContent = nil;
    self._idexIsSetPos = nil;
   	if self._contentSize ~= nil then
		globalManager.poolManager:putVector2(self._contentSize);
		self._contentSize = nil;
	end
   	if self._viewPortSize ~= nil then
		globalManager.poolManager:putVector2(self._contentSize);
		self._viewPortSize = nil;
	end
	self._viewPortSize = nil;
    self:poolDispose();
end
