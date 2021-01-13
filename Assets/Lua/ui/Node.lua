Node = class("Node");

function Node:ctor()
	self.go = nil;
	self._size = nil;
	self._position = nil;
	self._isShow = true;
	self.transform = nil;
	self.component = nil;

	self._cbTarget = nil;
	self._clickCB = nil;
	self._downCB = nil;
	self._upCB = nil;
	self._beginDrag = nil;
	self._drag = nil;
	self._endDrag = nil;
	self._param1 = nil;
	self._param2 = nil;

	self._abName = nil;
	self._assetName = nil
	self._assetList = nil;

	self._childrenList = nil;
end

function Node:setObject(object,transform)
	self:destroyGo();
	self.go = object;
	if transform ~= nil then
		self.transform = transform;
	else
		self.transform = self.go:GetComponent(typeof(UnityEngine.RectTransform));
		if self.transform == nil then
			self.transform = self.go:AddComponent(typeof(UnityEngine.RectTransform));
			self.transform.pivot = globalManager.kCreator.pivotPoint0;
			self.transform.anchorMax = globalManager.kCreator.pivotPoint1;
			self.transform.anchorMin = globalManager.kCreator.pivotPoint1;
		end
	end

	self:createComponent();
end

function Node:setByPrefab(prefab)
	local go = UnityEngine.GameObject.Instantiate(prefab);
	self:setObject(go);
end

function Node:loadNodeAb(abName,assetName)
	self._abName = abName;
	self._assetName = assetName;
	if self._abName ~= nil then
		globalManager.loaderManager:loadAB(self._abName,self._assetName,self.aBComplete,self);
	else
		print("!!ERROR!!!未传入ABName");
	end
end

function Node:aBComplete(abName,assetName,ab,asset)
	if asset ~= nil then
		self._assetList = parseABContent(ab);
		self:setByPrefab(asset);
	else
		print("!!!ERROR!!!ab加载错误",abName,assetName,asset);
	end
end

function Node:createComponent()

end


function Node:getChildByName(name,typeStr)
	if(self._childrenList == nil)then self._childrenList = {}; end
	local bnode = self._childrenList[name];
	if(bnode ~= nil)then return bnode; end
	local transform = self.transform:Find(name);
	if(transform == nil)then return nil; end
	if(typeStr == nil)then
		print("########缺少child类型，无法查找！！！");
	end

	if(typeStr == "Layer")then
		bnode = globalManager.poolManager:createNode(true);
	elseif(typeStr == "Image")then
		bnode = globalManager.poolManager:createImage(true);
	elseif(typeStr == "Button")then
		bnode = globalManager.poolManager:createButton(true);
	elseif(typeStr == "Label")then
		print("Label =============",name,transform.anchoredPosition.y);
		bnode = globalManager.poolManager:createLabel(true);
	elseif(typeStr == "RichLabel")then
		bnode = globalManager.poolManager:createRichLabel(true);
	elseif(typeStr == "Input")then
		bnode = InputLabel:new();
	elseif(typeStr == "List")then
		bnode = ScrollView:new();
	elseif(typeStr == "ListView")then
		bnode = ListView:new();
	end
	bnode:setObject(transform.gameObject,transform);
	self._childrenList[name] = bnode;
	return bnode;
end

function Node:setParent(parentTransform)
	self.transform:SetParent(parentTransform,false);
end

function Node:addNode(uiNode)
	if(self.transform == nil or uiNode == nil)then return; end
	uiNode:setParent(self.transform);
end

function Node:setTouchEnabled(v)
	if(self.component == nil or self.component.raycastTarget == vWW)then
		return;
	end
	self.component.raycastTarget = v;
end

--paramType默认为0，不传参，1回调x,y，2回调eventData
function Node:addTouchCallBack(clickCB,target,downCB,upCB,paramType)
	if(clickCB == nil and downCB == nil and upCB == nil)then return end;
	self._cbTarget = target;
	self._clickCB = clickCB;
	self._downCB = downCB;
	self._upCB = upCB;
	self:addTouchMouseTrigger(paramType);
end

function Node:addTouchMouseTrigger(paramType)
	if(self._mouseTrigger == nil)then
		self:setTouchEnabled(true);
		self._mouseTrigger = self.go:AddComponent(typeof(TouchTrigger));
		self._mouseTrigger:setTouchEnabled(true);
		if(paramType ~= nil and paramType ~= 0)then
			self._mouseTrigger:setParamStyle(paramType);
		end
	end
	self._mouseTrigger:setLuaCallback(self.clickHandler,self,self.downHandler,self.upHandler);
end

function Node:clickHandler(self,param1,param2)
	if(self._clickCB ~= nil)then
		self._clickCB(self._cbTarget,self,param1,param2);
	end
end

function Node:downHandler(self,param1,param2)
	self._param1 = param1;
	self._param2 = param2;
	if(self._downCB ~= nil)then
		self._downCB(self._cbTarget,self,param1,param2);
	end
end
function Node:upHandler(self,param1,param2)
	self._param1 = nil;
	self._param2 = nil;
	if(self._upCB ~= nil)then
		self._upCB(self._cbTarget,self,param1,param2);
	end
end

function Node:addDragCallBack(target,beginDrag,drag,endDrag,paramType)
	if(self._mouseTrigger == nil)then
		self:setTouchEnabled(true);
		self._mouseTrigger = self.go:AddComponent(typeof(DragTrigger));
		self._mouseTrigger:setTouchEnabled(true);
		if(paramType ~= nil and paramType ~= 0)then
			self._mouseTrigger:setParamStyle(paramType);
		end
		if(beginDrag ~= nil or drag ~= nil or endDrag ~= nil)then
			self._cbTarget = target;
			self._beginDrag = beginDrag;
			self._drag = drag;
			self._endDrag = endDrag;
			self._mouseTrigger:setLuaCallback(nil,self,self.beginDragHandler,self.endDragHandler,nil,self.dragHandler);
		end
	end
end

function Node:beginDragHandler(self,param1,param2)
	if(self._beginDrag ~= nil)then
		self._beginDrag(self._cbTarget,self,param1,param2);
	end
end
function Node:dragHandler(self,param1,param2)
	if(self._drag ~= nil)then
		self._drag(self._cbTarget,self,param1,param2);
	end
end
function Node:endDragHandler(self,param1,param2)
	if(self._endDrag ~= nil)then
		self._endDrag(self._cbTarget,self,param1,param2);
	end
end

function Node:setZButtom()
	self.transform:SetAsFirstSibling();
end

function Node:setZTop()
	self.transform:SetAsLastSibling();
end

function Node:setName(name)
	if self.go ~= nil then
		self.go.name = name;
	end
end

function Node:setVisible(bShow)
	if bShow then
		self:show();
	else
		self:hide();
	end
end

function Node:getScale()
	if(self._scale == nil)then
		local scale = self.transform.localScale;
		self._scale = globalManager.poolManager:createVector3(scale.x,scale.y,scale.z);
	end
	return self._scale;
end

function Node:setScale(x,y,z)
	self._scale = self:getScale();
	if(self._scale.x == x and self._scale.y == y and self._scale.z == z)then return; end
	if(x ~= nil)then self._scale.x = x; end
	if(y ~= nil)then self._scale.y = y; end
	if(z ~= nil)then self._scale.z = z; end
	self.transform.localScale = self._scale;
end

function Node:setLayer(layer)
	if self.go ~= nil then
		self.go.layer = layer;
	end
end

function Node:show()
	self._isShow = true;
	self:updateShowHide();
end

function Node:hide()
	self._isShow = false;
	self:updateShowHide();
end

function Node:updateShowHide()
	if self.go ~= nil and not self.go:Equals(nil) and self.go.SetActive ~= nil then
		self.go:SetActive(self._isShow);
	end
end

function Node:setPivot(pivot)
	if(self.transform == nil)then return; end
	self.transform.pivot = pivot;
end
function Node:setAnchor(maxVector,minVector)
	if(self.transform == nil)then return; end
	self.transform.anchorMax = maxVector;
	self.transform.anchorMin = minVector;
end

function Node:setPosition(x,y,z)
	local pos = self:getPosition();
	if x ~= nil then
		pos.x = x;
	end
	if y ~= nil then
		pos.y = y;
	end
	if z ~= nil then
		pos.z = z;
	end
	self.transform.anchoredPosition = pos;
end

--是否吞噬点击事件
function Node:setIsSwallow(v)
	if(self._mouseTrigger == nil)then
		return;
	end
	self._mouseTrigger:setIsSwallow(v);
end


function Node:getPosition()
	if self._position == nil then
		local pos = self.transform.anchoredPosition;
		self._position = globalManager.poolManager:createVector3(pos.x,pos.y,pos.z);
	end
	return self._position;
end

function Node:setSize(width,height)
	local size = self:getSize();
	if width ~= nil then 
		size.x = width;
	end
	if height ~= nil then
		size.y = height;
	end
	self.transform.sizeDelta = size;
end

function Node:getSize()
	if(self._size == nil)then
		local size = self.transform.sizeDelta;
		self._size = globalManager.poolManager:createVector2(size.x,size.y);
	end
	return self._size;
end

function Node:doClear()
	self._isShow = true;

	self._cbTarget = nil;
	self._clickCB = nil;
	self._downCB = nil;
	self._upCB = nil;
	self._beginDrag = nil;
	self._drag = nil;
	self._endDrag = nil;
	self._param1 = nil;
	self._param2 = nil;
	
	if self._size ~= nil then
		globalManager.poolManager:putVector2(self._size);
		self._size = nil;
	end
	if self._position ~= nil then
		globalManager.poolManager:putVector3(self._position);
		self._position = nil;
	end

	if self._abName ~= nil then
		globalManager.loaderManager:removeAB(self._abName,self.aBComplete,self,self._assetName);
		self._abName = nil;
		self._assetName = nil
		self._assetList = nil;
	end
end

function Node:dispose()
	globalManager.poolManager:putNode(self);
end

function Node:destroyGo()
	if(self._childrenList ~= nil)then
		for k, v in pairs(self._childrenList) do
			v:dispose();
			v = nil;
		end
		self._childrenList = nil;
	end
	if(self.go ~= nil)then
		UnityEngine.GameObject.Destroy(self.go);
		self.go = nil;
	end
	self.component = nil;
	self.transform = nil;
end

function Node:poolDispose()
	if self.__isPoolDispose then return; end
	self.__isPoolDispose = true;
	self:doClear();
	self:destroyGo();
	self.__isInPoolList = false;
	self.__isForPoolList = false;
end