ListView = class("ListView",Node);

function ListView:ctor()
	self._viewRect = nil;--滚动可视窗口(=遮罩大小)
	self._container = nil;--装视图的容器
	self._scrollRect = nil;
	self._contentSize = nil;
	self._padding = {top = 0, right = 0, bottom = 0, left = 0};--边距
	self._margin = 0;--item间隙
	self._itemList = {};--list数组(itemview)
	self._forceCenter = false;
	self._jumpItemCb = nil;
	self._jumpItemTarget = nil;
	self._endGap = 0;
	ListView.super.ctor(self);
end

function ListView:createComponent()
	self._container = self.go.transform:Find("Viewport/Content");
	self.component = self.go:GetComponent(typeof(UIScrollContent));
	self._scrollRect = self.go:GetComponent(typeof(UnityEngine.UI.ScrollRect));

	local masks = self.go:GetComponentsInChildren(typeof(UnityEngine.UI.Mask), true);
	if masks ~= nil and masks.Length > 0 then
		self._viewRect = masks[0].transform;
	end
	self:setVertical(true);
end

-- 设置边距
function ListView:setPadding(top, right, bottom, left)
	self._padding.top = top or 0;
	self._padding.right = right or 0;
	self._padding.bottom = bottom or 0;
	self._padding.left = left or 0;
	self:refresh();
end

function ListView:setPositionChangeType(scrollPosChangeType)
	-- 滚动触发函数
	-- if scrollPosChangeType == globalConst.uiConst.scrollPosChangeType.scrollJumpItem then
	-- 	self.component.onPositionChange = function ()
	-- 		self:scrollJumpItem();
	-- 	end;
	-- elseif scrollPosChangeType == globalConst.uiConst.scrollPosChangeType.scrollHandler then
	-- 	self.component.onPositionChange = function ()
	-- 		self:scrollHandler();
	-- 	end;
	-- end
end

function ListView:setScrollCallBack(scrollCb,scrollTarget)
	if scrollCb == nil or scrollTarget == nil then
		return;
	end
	self:setPositionChangeType(globalConst.uiConst.scrollPosChangeType.scrollHandler);
	self._scrollCb = scrollCb;
	self._scrollTarget = scrollTarget;
end

function ListView:scrollHandler()
	if self._scrollCb ~= nil and self._scrollTarget ~= nil then
		self._scrollCb(self._scrollTarget);
	end
end

--先这样写，后面再重构
--isHorizontal:横纵滑动
--padGap1\padGap2 前后留白，第一个和最后一个要固定在中间的时候要传itemSize大小的留白
--endGap 倒数第二个要固定在中间的时候，传1
function ListView:setJumItemData(isHorizontal, padGap1, padGap2, endGap)
	if isHorizontal then
		self:setHorizontal(true);
		self:setPadding(nil, padGap1, nil, padGap2);
	else
		self:setVertical(true);
		self:setPadding(padGap1, nil, padGap2, nil);
	end
	self._endGap = endGap;
end

--直接翻页跳转到对应格子的回调 beginGap:跳转的起始位置，
function ListView:setJumpItemCallBack(jumpItemCb, jumpItemTarget)
	if jumpItemCb == nil or jumpItemTarget == nil then
		return;
	end
	self._jumpItemCb = jumpItemCb;
	self._jumpItemTarget = jumpItemTarget;
end

function ListView:scrollJumpItem()
	local selectIndex = -1;
	local itemLen = #self._itemList;
	if itemLen > 0 then
		if self._scrollRect.horizontal and not self._scrollRect.vertical then
			--水平滑动
			local item = self._itemList[1];
			if item ~= nil then
				--加0.5用来实现四舍五入math.floor(5.123 + 0.5)
				selectIndex = math.floor((self._viewRect.sizeDelta.x / 2 - self._container.anchoredPosition.x - self._padding.left) / (item:getSize().x + self._margin) + 0.5);
				if selectIndex < 0 then
					selectIndex = 0;
				elseif selectIndex >= itemLen - self._endGap then
					selectIndex = itemLen - 1 - self._endGap;
				end
				item = self._itemList[selectIndex + 1];
				if item ~= nil then
					local destx = self._viewRect.sizeDelta.x / 2 - item:getPosition().x - item:getSize().x / 2;
					if math.abs(destx) >  self._container.rect.width - self._viewRect.rect.width then
						destx = - self._container.rect.width + self._viewRect.rect.width;
					end
					--跳转到需要选中的item
					self:scrollToPos(destx);
				end
			end
		   
		elseif not self._scrollRect.horizontal and self._scrollRect.vertical then
			--垂直滑动
			local item = self._itemList[1];
			if item ~= nil then
				--加0.5用来实现四舍五入math.floor(5.123 + 0.5)
				selectIndex = math.floor(( - self._viewRect.sizeDelta.y / 2 + self._container.anchoredPosition.y + self._padding.top) / (item:getSize().y + self._margin) + 0.5);
				if selectIndex < 0 then
					selectIndex = 0;
				elseif selectIndex >= itemLen - self._endGap then
					selectIndex = itemLen - 1 - self._endGap;
				end
				item = self._itemList[selectIndex + 1];
				if item ~= nil then
					local destY = item:getSize().y / 2 - item:getPosition().y - self._viewRect.sizeDelta.y / 2;
					if math.abs(destY) >  self._container.rect.height then
						destY = - self._container.rect.height;
					end
					--跳转到需要选中的item
					self:scrollToPos(destY);
				end
			end
			
		end
		--回调出去，传递选中的itemIndex
		if self._jumpItemCb ~= nil and self._jumpItemTarget ~= nil and selectIndex >= 0 then
			self._jumpItemCb(self._jumpItemTarget, selectIndex + 1);
		end
	end
	
end

-- 设置间距
function ListView:setMargin(margin)
	self._margin = margin or 0;
	self:refresh();
end

-- 滚到顶部
function ListView:scrollToTop()
	self:stopMovement();
	self._container.anchoredPosition = Vector2.zero;
end

-- 滚到底部
function ListView:scrollToBottom()
	self:stopMovement();
	local jumpPos = Vector2.zero;
	if self._scrollRect.horizontal then
		jumpPos.x = -(self:getContentSize().x - self._viewRect.rect.width);
	else
		jumpPos.y = self:getContentSize().y - self._viewRect.rect.height;
	end
	self._container.anchoredPosition = jumpPos;
end

function ListView:isEnd(pos)
	if self._scrollRect.horizontal then
		local endX = -(self._container.rect.width - self._viewRect.rect.width);
		if pos == nil then
			pos = self._container.anchoredPosition.x;
		end
		return endX >= pos;
	else
		local endY = self._container.rect.height - self._viewRect.rect.height;
		if pos == nil then
			pos = self._container.anchoredPosition.y;
		end
		return pos >= endY;
	end
end

function ListView:getEnd()
	if self._scrollRect.horizontal then
		return -(self._container.rect.width - self._viewRect.rect.width);
	else
		return self._container.rect.height - self._viewRect.rect.height;
	end
end

-- 滚到指定的位置
function ListView:scrollToPos(pos)
	self:stopMovement();
	local jumpPos = Vector2.zero;
	if self:isEnd(pos) then
		pos = self:getEnd();
	end
	if self._scrollRect.horizontal then
		jumpPos.x = pos;
	else
		jumpPos.y = pos;
	end
	self._container.anchoredPosition = jumpPos;
end

function ListView:stopMovement()
	if(self._scrollRect ~= nil)then
		self._scrollRect:StopMovement();
	end
end

--获取容器的高
function ListView:getViewportHeight()
	return self._viewRect.rect.height;
end

function ListView:getViewportWidth()
	return self._viewRect.rect.width;
end

function ListView:forbidScoll()
	self._scrollRect.vertical = false;
	self._scrollRect.horizontal = false;
end

function ListView:getCurScollPositionX()
	return self._container.anchoredPosition.x;
end

--listView不允许双轴滚动
function ListView:setHorizontal(value)
	self._scrollRect.horizontal = value;
	self._scrollRect.vertical = not value;
end
function ListView:setVertical(value)
	self._scrollRect.vertical = value;
	self._scrollRect.horizontal = not value;
end

function ListView:setElasticity(value)
	self._scrollRect.elasticity = value;
end

function ListView:setMoveType(value)
	self._scrollRect.movementType = value;
end

function ListView:setAllItemForceCentered(value)
	--listview列表里面有时候存在不同宽度，不同长度的Item，需要根据最大长度的Item来居中显示
	self._forceCenter = value;
end

function ListView:refresh(isImmediately)
	local len = #self._itemList;
	if(len <= 0)then
		self:scrollToTop();
		return;
	end

	local currentX = self._padding.left;
	local currentY = -self._padding.top;
	local totalW = 0;
	local totalH = 0;
	for i = 1,len do
		local item = self._itemList[i];
		if(item ~= nil)then
			item:setPosition(currentX,currentY,nil,isImmediately);
			if(self._scrollRect.horizontal)then
				currentX = currentX + self._margin + item:getSize().x;
				if(totalH < item:getSize().y)then totalH = item:getSize().y; end
			else
				currentY = currentY - self._margin - item:getSize().y;
				if(totalW < item:getSize().x)then totalW = item:getSize().x; end
			end
		end
	end

	if(self._scrollRect.horizontal)then
		totalW = currentX - self._margin + self._padding.right;
		if(self._forceCenter)then
			for i = 1,len do
				local item = self._itemList[i];
				if(item ~= nil)then
					local offsetY = (totalH - item:getSize().y) / 2;
					item:setPosition(nil,offsetY,true,isImmediately);
				end
			end
		end
	else
		if(self._forceCenter)then
			totalW = self._viewRect.rect.width;
			for i = 1,len do
				local item = self._itemList[i];
				if(item ~= nil)then
					local offsetX = (totalW - item:getSize().x) / 2;
					item:setPosition(offsetX,nil,true,isImmediately);
				end
			end
		end
		totalH = -currentY - self._margin + self._padding.bottom;
	end

	self:setContentSize(totalW,totalH);
end

function ListView:getContentSize()
	if(self._contentSize == nil)then
		local size = self._container.sizeDelta;
		self._contentSize = globalManager.poolManager:createVector2(size.x,size.y);
	end
	return self._contentSize;
end
-- 设置容器大小
function ListView:setContentSize(width,height)
	if self._scrollRect ~= nil and self._scrollRect.horizontal then
		if self._viewRect ~= nil and width < self._viewRect.rect.width then
			width = self._viewRect.rect.width+1;
		end
	else
		if self._viewRect ~= nil and height < self._viewRect.rect.height then
			height = self._viewRect.rect.height+1;
		end
	end
	local contentSize = self:getContentSize();
	if width ~= nil then 
		contentSize.x = width;
	end
	if height ~= nil then
		contentSize.y = height;
	end
	self._container.sizeDelta = contentSize;
end

-- 设置可视窗口大小
function ListView:setViewPortSize(width,height)
	self._viewRect.sizeDelta = globalManager.poolManager:createVector2(width,height);
	if self._listParentNode ~= nil then
		self._listParentNode.sizeDelta = globalManager.poolManager:createVector2(width,height);
	end
end

--在最后添加一个item
function ListView:pushBackItem(item)
	item:setParent(self._container);
	table.insert(self._itemList,item);
	self:refresh();
end
--在指定index位置插入一个item
function ListView:insertItem(item,index)
	item:setParent(self._container);
	table.insert(self._itemList,index,item);
	self:refresh();
end
--移除指定index位置的item(index默认为self._itemList长度即最末尾item),并且是否执行该item的dispose方法(isDispose默认为true)
function ListView:removeItem(index,isDispose)
	if(index == nil)then index = #self._itemList; end
	if(index <= 0)then return; end
	local item = self._itemList[index];
	if(item == nil)then return; end
	if(isDispose == false)then
		item:setParent(nil);
	else
		item:dispose();
	end
	table.remove(self._itemList,index);
	self:refresh();
end
--移除所有item,并且是否执行所有item的dispose方法(isDispose默认为true)
function ListView:removeAllItems(isDispose)
	local len = #self._itemList;
	if(len <= 0)then return; end
	for i = 1,len do
		local item = self._itemList[i];
		if(item ~= nil)then
			if(isDispose == false)then
				item:setParent(nil);
			else
				item:dispose();
			end
		end
	end
	self._itemList = {};
	self:refresh();
end

function ListView:getItem(index)
	return self._itemList[index];
end

function ListView:getItems()
	return self._itemList;
end

--任务特殊处理增加的接口
function ListView:setItems(list)
	self._itemList = list;
	self:refresh(true);
end

function ListView:getViewPortSize()
	return self._viewRect.sizeDelta;
end

function ListView:dispose()
	self._viewRect = nil;
	self._scrollRect = nil;
	self._padding = nil;
	self:removeAllItems();
	self._itemList = nil;
	self._container = nil;
	self._jumpItemCb = nil;
	self._jumpItemTarget = nil;
	if self._contentSize ~= nil then
		globalManager.poolManager:putVector2(self._contentSize);
		self._contentSize = nil;
	end
	self:poolDispose();
end
