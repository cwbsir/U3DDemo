--对象池
--__isInPoolList表示对象是否处理对象池里面
PoolManager = class("PoolManager");

function PoolManager:ctor()
	self.vector2List = {};
	self.vector3List = {};

	self.uiNodeList = {};
	self.uiLabelList = {};
	self.uiImageList = {};
	self.uiButtonList = {};
	self.uiRichLabelList = {};

	self.quoteDataList = {};
	

	self.types = {};
	self.types["Node"] = {Node,self.uiNodeList,10}; 
	self.types["Label"] = {Label,self.uiLabelList,10};
	self.types["Image"] = {Image,self.uiImageList,10};
	self.types["Button"] = {Button,self.uiImageList,10};
	self.types["RichLabel"] = {RichLabel,self.uiRichLabelList,10};

	self.types["QuoteData"] = {QuoteData,self.quoteDataList,10};

end

function PoolManager:createItem(usePool,itemType)
	if usePool == nil then usePool = true;end
	
	local typeClass = self.types[itemType][1];
	local poolList = self.types[itemType][2];
	if globalData.USE_POOL and usePool then
		local item = nil;
		if #poolList > 0 then
			item = table.remove(poolList,1);
			if item.poolShow ~= nil then
				item:poolShow();
			end
			-- 从池中取出标记一下
			item.__isInPoolList = false;
			-- 使用完需要放回缓存池
			item.__isForPoolList = true;
			return item,false;
		else
			item = typeClass:new();
			item.__isInPoolList = false;
			-- 使用完需要放回缓存池
			item.__isForPoolList = true;
			return item,true;
		end
	end
	-- 直接创建
	item = typeClass:new();
	-- 是否在池中
	item.__isInPoolList = false;
	-- 不放回缓存池
	item.__isForPoolList = false;
	return item,true;
end

function PoolManager:putItem(item,itemType)
	-- 防止重复放入池中
	if item.__isInPoolList then return;end
	local typeClass = self.types[itemType][1];
	local poolList = self.types[itemType][2];
	local limitCount = self.types[itemType][3];
	if item.__cname ~= typeClass.__cname or  #poolList >= limitCount or globalData.USE_POOL == false or item.__isForPoolList == false then
		item:poolDispose();
	else
		item:doClear();
		if item.__isInPoolList == false then
			table.insert(poolList,item);
			-- 放入池中，标记一下
			item.__isInPoolList = true;
		end
	end
end

function PoolManager:createQuoteData(usePool)
	return self:createItem(usePool,"QuoteData");
end

function PoolManager:createNode(usePool)
	return self:createItem(usePool,"Node");
end

function PoolManager:createLabel(usePool)
	return self:createItem(usePool,"Label");
end

function PoolManager:createImage(usePool)
	return self:createItem(usePool,"Image");
end

function PoolManager:createButton(usePool)
	return self:createItem(usePool,"Button");
end

function PoolManager:createRichLabel(usePool)
	return self:createItem(usePool,"RichLabel");
end

function PoolManager:createVector2(x,y)
	local len = #self.vector2List;
	local v = nil;
	if(len > 0)then
		v = table.remove(self.vector2List,1);
	end
	if(v == nil)then
		v = Vector2.zero;
	end
	if(x ~= nil or y ~= nil)then
		v:Set(x,y);
	end

	return v;
end

function PoolManager:putVector2(vec2)
	vec2:Set(0,0);
	table.insert(self.vector2List,vec2);
end

function PoolManager:createVector3(x,y,z)
	local len = #self.vector3List;
	local v = nil;
	if(len > 0)then
		 v = table.remove(self.vector3List,1);
	end
	if(v == nil)then
		v = Vector3.zero;
	end
	if(x ~= nil or y ~= nil or z ~= nil)then
		v:Set(x,y,z);
	end

	return v;
end

function PoolManager:putVector3(vec3)
	vec3:Set(0,0,0);
	table.insert(self.vector3List,vec3);
end

function PoolManager:putQuoteData(item)
	self:putItem(item,"QuoteData");
end

function PoolManager:putNode(item)
	self:putItem(item,"Node");
end

function PoolManager:putLabel(item)
	self:putItem(item,"Label");
end

function PoolManager:putImage(item)
	self:putItem(item,"Image");
end

function PoolManager:putButton(item)
	self:putItem(item,"Button");
end

function PoolManager:putRichLabel(item)
	self:putItem(item,"RichLabel");
end