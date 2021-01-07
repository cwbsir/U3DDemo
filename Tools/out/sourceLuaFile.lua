function clone(object)
local lookup_table = {};
local function _copy(object)
if(type(object) ~= FUCK0U)then
return object;
elseif(lookup_table[object])then
return lookup_table[object];
end
local new_table = {};
lookup_table[object] = new_table;
for key, value in pairs(object) do
new_table[_copy(key)] = _copy(value);
end
return setmetatable(new_table, getmetatable(object));
end
return _copy(object);
end
function newObject(name)
return UnityEngine.GameObject(name);
end

function screen2LocalPos(screenPos,transform)
local result,transPos = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(transform, screenPos, globalManager.cameraManager.uiCamera, nil);
return transPos;
end

function parseABContent(abContent)
local prefabList = abContent:LoadAllAssets(typeof(UnityEngine.GameObject));
local destList = {};
if(prefabList == nil)then return destList; end;
local len = prefabList.Length - 1;
for i = 0,len,1 do
local prefab = prefabList[i];
destList[prefab.name] = prefab;
end
return destList;
end


function strSplitToInt(str,token)
if (str == "" or str == nil) then return {}; end
token = token or FUCK1U;
local ret = {};
local strList = string.split(str,token);
for i=1,#strList do
local num = tonumber(strList[i]);
table.insert(ret,num);
end
return ret;
end


function strSplitToInts(str,tokens)
if (str == "" or str == nil) then return {}; end
local token_first = FUCK2U;
local token_sec = FUCK3U;
if tokens ~= nil then
token_first = tokens[1];
token_sec = tokens[2];
end
local ret = {};
local listFirst = string.split(str,token_first);
for i=1,#listFirst do
local listSec = string.split(listFirst[i],token_sec);
for j=1,#listSec do
listSec[j] = tonumber(listSec[j]);
end
table.insert(ret,listSec);
end
return ret;
end

function table.getLength(t)
local length = 0;
for k, v in pairs(t) do
length = length + 1;
end
return length;
end


function table.merge(...)
local tableList = {...};
if #tableList <= 0 then
return {};
end
local origin = {};
for i=1,#tableList do
if tableList[i] ~= nil then
for _,data in ipairs(tableList[i]) do
if data ~= nil then
table.insert(origin,data);
end
end
end
end
return origin;
end

function arrayIndexOf(table,t)
local len = #table;
for i = 1,len do
if(table[i] == t)then
return i;
end
end
return -1;
end

function math.round(num, numDecimalPlaces)
local mult = 10 ^(numDecimalPlaces or 0)
return math.floor(num * mult + 0.5) / mult
end





function mathRandom(n, m, randomCount)
local randomFunc = function()
if m ~= nil and type(m) == FUCK4U then
return math.random(n, m);
elseif n ~= nil and type(n) == FUCK5U then
return math.random(n);
else
return math.random();
end
end
if randomCount == nil or type(randomCount) ~= FUCK6U or randomCount <= 0 then
return randomFunc();
end
local randomNumList = {};
for i=1,randomCount do
table.insert(randomNumList, randomFunc())
end
return randomNumList;
end

function arraySplitByCount(array,count)
if count == 1 then return {array} end;

local ret = {};
local len = #array;

local amount = math.ceil(len/count);

for i=1,count do
local temp = {};
for j=1,amount do
local index = (i-1)*amount+j;

if array[index] ~= nil then
table.insert(temp,array[index]);
end
end
table.insert(ret,temp);
end
return ret;
end

function printArray(array,preStr)
for i=1,#array do
print(preStr,i,array[i]);
end
end
EventDispatcher = class(FUCK7U);

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
QuoteData = class(FUCK8U);

function QuoteData:ctor()
self.flag = 0;
self.target = nil;
self.callback = nil;
self.assetName = nil;
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
TemplateParser = class(FUCK9U);

function TemplateParser:ctor()
self._data = nil;
self._quoteData = nil;
self._fileCount = 0;
self._parseInfos = {};
self._currentParseInfo = nil;
self._hasParseBytes = 0;
self._maxParseBytes = 10000;
end

function TemplateParser:start(data,callback,target)
self._quoteData = globalManager.poolManager:createQuoteData();
self._quoteData:init(callback,target);

local pos = 4;
self._fileCount = data[pos + 1] * 256 + data[pos];



pos = pos + 2;
for i = 1,self._fileCount,1 do
local id = data[pos + 1] * 256 + data[pos];
pos = pos + 2;
local fileLen = data[pos + 3] * 16777216 + data[pos + 2] * 65536 + data[pos + 1] * 256 + data[pos];
pos = pos + 4;
local byteArray = ByteArray();

byteArray:loadBytesOffset(data,pos,fileLen);
pos = pos + fileLen;

local templateList = self:getTempById(id);
if(templateList ~= nil)then
templateList.temp_id = id;
templateList:init(byteArray,fileLen);
table.insert(self._parseInfos,templateList);
end
end
globalManager.tickManager:addTick(self.tick,self);
end

function TemplateParser:setMaxParseBytes(v)
self._maxParseBytes = v;
end

function TemplateParser:tick(delta)
for i = 1,1000000000,1 do
if(self._currentParseInfo == nil)then
if(#self._parseInfos <= 0)then
self:doComplete();
break;
else
self._currentParseInfo = table.remove(self._parseInfos,1);
end
else
if(self._currentParseInfo.parseComplete1)then
self._currentParseInfo = nil;
else
local dPosition = self._currentParseInfo:getCurReadPos();
self._currentParseInfo:parse();
dPosition = self._currentParseInfo:getCurReadPos() - dPosition;
self._hasParseBytes = self._hasParseBytes + dPosition;
if(self._hasParseBytes >= self._maxParseBytes)then
self._hasParseBytes = 0;
break;
end
end
end
end
end

function TemplateParser:getTempById(id)
if id == 1 then
return globalConst.landTemplateList;
elseif id == 2 then
return globalConst.pokerHandTemplateList;

end
return nil;
end

function TemplateParser:doComplete()
globalManager.tickManager:removeTick(self.tick,self);
self._data = nil;
self._parseInfos = nil;
self._currentParseInfo = nil;
self._quoteData.callback(self._quoteData.target);
self._quoteData = nil;
end
KCreator = class(FUCK10U);


function KCreator:ctor()
self.pivotPoint0 = Vector2.New(0.5,0.5);
self.pivotPoint1 = Vector2.New(0,1);
self.pivotPoint2 = Vector2.New(0.5,1);
self.pivotPoint3 = Vector2.New(1,1);
self.pivotPoint4 = Vector2.New(0,0.5);
self.pivotPoint5 = Vector2.New(1,0.5);
self.pivotPoint6 = Vector2.New(0,0);
self.pivotPoint7 = Vector2.New(1,0);
self.pivotPoint8 = Vector2.New(0.5,0);
end



function KCreator:createNode(name,isPool)
name = name or FUCK11U;
local node,isNew = globalManager.poolManager:createNode(isPool);
if isNew then
local object = newObject(name)
node:setObject(object);
else
node:setName(name);
node:show();
end

node:setPivot(self.pivotPoint0);
node:setAnchor(self.pivotPoint1,self.pivotPoint1);

return node;
end

function KCreator:createLabel(fontSize,name,isPool)
name = name or FUCK12U;
local label,isNew = globalManager.poolManager:createLabel(isPool);
if isNew then
local object = UnityEngine.GameObject.Instantiate(globalData.uiPrefabs[FUCK13U]);
label:setObject(object);
else
label:show();
end
label:setName(name);
label:setRich(false);
label:setLineSpacing(1);
label:setSize(100,100,true,true);
label:setFontSize(fontSize or 20);
label:setFontStyle(UnityEngine.FontStyle.Normal);
label:setPivot(self.pivotPoint0);
label:setAnchor(self.pivotPoint1,self.pivotPoint1);
return label;
end

function KCreator:createImage(name,isPool)
name = name or FUCK14U;
local image,isNew = globalManager.poolManager:createImage(isPool);
if isNew then
local object = newObject(name)
image:setObject(object);
else
image:setName(name);
image:show();
end

image:setPivot(self.pivotPoint0);
image:setAnchor(self.pivotPoint1,self.pivotPoint1);

return image;
end

function KCreator:createButton(name,isPool)
name = name or FUCK15U;
local button,isNew = globalManager.poolManager:createButton(isPool);
if isNew then
local object = newObject(name);
button:setObject(object);
else
button:setName(name);
button:show();
end

button:setPivot(self.pivotPoint0);
button:setAnchor(self.pivotPoint1,self.pivotPoint1);

return button;
end

function KCreator:createRichLabel(fontSize,name,isPool)
name = name or FUCK16U;
local label,isNew = globalManager.poolManager:createRichLabel(isPool);
if isNew then
local object = newObject(name);
label:setObject(object);
else
label:show();
end
label:setName(name);
label:setRich(true);
label:setLineSpacing(1);
label:setSize(100,100,true,true);
label:setPivot(self.pivotPoint0);
label:setFontSize(fontSize or 20);
label:setFontStyle(UnityEngine.FontStyle.Normal);
label:setAnchor(self.pivotPoint1,self.pivotPoint1);
return label;
end


function KCreator:createInputLabel(name)
name = name or FUCK17U;
local object = UnityEngine.GameObject.Instantiate(globalData.uiPrefabs[FUCK18U]);
object.name = name;

local inputLabel = InputLabel:new();
inputLabel:setObject(object);
inputLabel:setPivot(self.pivotPoint0);
inputLabel:setAnchor(self.pivotPoint1,self.pivotPoint1);
inputLabel:setAlign(UnityEngine.TextAnchor.MiddleCenter);
inputLabel:setHOverflow(UnityEngine.HorizontalWrapMode.Overflow);
inputLabel:setVOverflow(UnityEngine.VerticalWrapMode.Overflow);
inputLabel:setColor(globalConst.colorConst.black);
inputLabel:setFontSize(20);
return inputLabel;
end


function KCreator:createListView(name)
local object = UnityEngine.GameObject.Instantiate(globalData.uiPrefabs[FUCK19U]);
local listView = ListView:new();
listView:setObject(object);
return listView;
end


function KCreator:createScrollView(name)
local object = UnityEngine.GameObject.Instantiate(globalData.uiPrefabs[FUCK20U]);
local scrollView = ScrollView:new();
scrollView:setObject(object);
return scrollView;
end
Node = class(FUCK21U);

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
globalManager.loaderManager:loadAsset(self._abName,self._assetName,self.aBComplete,self);
else
print(FUCK22U);
end
end

function Node:aBComplete(abName,assetName,ab,asset)
if asset ~= nil then
self._assetList = parseABContent(ab);
self:setByPrefab(asset);
else
print(FUCK23U,abName,assetName,asset);
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
print(FUCK24U);
end

if(typeStr == FUCK25U)then
bnode = globalManager.poolManager:createNode(true);
elseif(typeStr == FUCK26U)then
bnode = globalManager.poolManager:createImage(true);
elseif(typeStr == FUCK27U)then
bnode = globalManager.poolManager:createButton(true);
elseif(typeStr == FUCK28U)then
print(FUCK29U,name,transform.anchoredPosition.y);
bnode = globalManager.poolManager:createLabel(true);
elseif(typeStr == FUCK30U)then
bnode = globalManager.poolManager:createRichLabel(true);
elseif(typeStr == FUCK31U)then
bnode = InputLabel:new();
elseif(typeStr == FUCK32U)then
bnode = ScrollView:new();
elseif(typeStr == FUCK33U)then
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
globalManager.loaderManager:removeAsset(self._abName,self.aBComplete,self,self._assetName);
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
Label = class(FUCK34U,Node);

function Label:ctor()
self.count = 1;
self._isRich = nil;
self._content = nil;
Label.super.ctor(self);
end

function Label:createComponent()
self.component = self.go:GetComponent(typeof(UnityEngine.UI.Text));
if self.component == nil then
self.component = self.go:AddComponent(typeof(UnityEngine.UI.Text));
self.component.font = globalData.defaultFont;
self.component.raycastTarget = false;
end
self.component.color.a = 1;
end

function Label:setColor(color,opacity)
local isChange = false;
if(color == nil)then
self._color = clone(self.component.color);
else
isChange = true;
self._color = clone(color);
end
if(opacity ~= nil and self._color.a ~= opacity)then
isChange = true;
self._color.a = opacity;
end
if(isChange)then self.component.color = self._color; end
end


function Label:setString(str)
if(self._content == str)then return; end
self._content = str;
if self.component ~= nil then
self.component.text = self._content;
end
end

function Label:setRich(isRich)
if isRich == nil or isRich == self._isRich then
return;
end
self._isRich = isRich;
self.component.supportRichText = isRich;
end

function Label:setFontSize(fontSize)
self.component.fontSize = fontSize;
end


function Label:setLineSpacing(value)
self.component.lineSpacing = value;
end





function Label:setFontStyle(style)
self.component.fontStyle = style;
end










function Label:setAlign(align)
self.component.alignment = align;
end



function Label:setHOverflow(overflow)
self.component.horizontalOverflow = overflow;
end



function Label:setVOverflow(overflow)
self.component.verticalOverflow = overflow;
end

function Label:doClear()
self._isRich = nil;
self._content = nil;
Label.super.doClear(self);
end

function Label:dispose()
globalManager.poolManager:putLabel(self);
end
Image = class(FUCK35U,Node);

function Image:ctor()
Image.super.ctor(self);
self._color = nil;
self._abName = nil;
self._sprite = nil;
self._material = nil;
self._spriteName = nil;
self._outTarget = nil;
self._outCallback = nil;
end

function Image:createComponent()
self.component = self.go:GetComponent(typeof(UnityEngine.UI.Image));
if self.component == nil then
self.component = self.go:AddComponent(typeof(UnityEngine.UI.Image));
self.component.raycastTarget = false;
end
end










function Image:loadUISprite(spriteName)
self:loadFromSpriteSheet(globalManager.pathManager:getCommonUIPath(),spriteName);
end

function Image:loadFromSpriteSheet(abName,spriteName)
if self._abName == abName and self._spriteName == spriteName then return; end
self:clearOutAB();
self:clearImage();
self._abName = abName;
self._spriteName = spriteName;
globalManager.spriteSheetList:loadSprite(self._abName,self._spriteName,self.spriteLoadComplete,self);
end

function Image:spriteLoadComplete(sprite,material)
self:__setSprite(sprite);
self:setMaterial(material);
self:__setShader();

local rect = sprite.textureRect;
self:setSize(rect.width,rect.height,true,true);
end

function Image:loadOutPic(abName,assetName,callback,target)
if abName == self._outAbName and assetName == self._outAssetName then return; end
self:clearOutAB();
self:clearImage();
self._outAbName = abName;
self._outAssetName = assetName;
self._outCallback = callback;
self._outTarget = target;


globalManager.loaderManager:loadAsset(abName,assetName,self.outPicLoadComplete,self);
end

function Image:outPicLoadComplete(abName,assetName,abContent,texture)
local sp = UnityEngine.Sprite.Create(texture,UnityEngine.Rect(0,0,texture.width,texture.height),Vector2(0, 0));
self:__setSprite(sp);

local rect = sp.textureRect;
self:setSize(rect.width,rect.height,true,true);

if self._outTarget ~= nil and self._outCallback ~= nil then
self._outCallback(self._outTarget);
end
end

function Image:setColor(color,opacity)
local isChange = false;
if(color == nil)then
self._color = self.component.color;
else
isChange = true;
self._color = clone(color);
self._color.a = self.component.color.a;
end
if(opacity ~= nil and self._color.a ~= opacity)then
isChange = true;
self._color.a = opacity;
end
if(isChange)then
self.component.color = self._color;
end
end


function Image:__setSprite(sprite)
if(self._sprite == sprite)then return; end
self._sprite = sprite;
self.component.sprite = sprite;
end

function Image:setMaterial(material)
if(self._material == material)then return; end
self._material = material;
self.component.material = material;
end

function Image:__setShader()
local material = self.component.material;
material.shader = globalConst.shaderType.PSD2UGUI_SPLIT_ALPHA;
end

function Image:clearImage()
self._sprite = nil;
self._material = nil;
if self._abName ~= nil then
globalManager.spriteSheetList:unloadSprite(self._abName,self._spriteName,self.spriteLoadComplete,self);
self._abName = nil;
self._spriteName = nil;
end
end

function Image:clearOutAB()
self._outTarget = nil;
self._outCallback = nil;
if self._outAbName ~= nil then
globalManager.loaderManager:removeAsset(self._outAbName,self._outAssetName,self.outPicLoadComplete,self);
self._outAbName = nil;
self._outAssetName = nil;
end
end

function Image:doClear()
self._color = nil;

self:clearImage();
self:clearOutAB();
Image.super.doClear(self);
end

function Image:dispose()
globalManager.poolManager:putImage(self);
end
Button = class(FUCK36U,Image);

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


function Button:setConstant(x,y)

self._constantX = x;
self._constantY = y;
end


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
InputLabel = class(FUCK37U,Label);

function InputLabel:ctor()
self._inputComponent = nil;
self._changeCallback = nil;
self._changeTarget = nil;
self._endCallback = nil;
self._endTarget = nil;
self._activeCallback = nil;
self._activeTarget = nil;

self._isInputing = false;

self._defaultStrLabel = nil;
InputLabel.super.ctor(self);
end

function InputLabel:createComponent()
self._inputComponent = self.go:GetComponent(typeof(UnityEngine.UI.InputField));
self._inputComponent.onValueChanged:AddListener(
function (value)
self:onValueChanged(value);
end)
self._inputComponent.onEndEdit:AddListener(
function (value)
self:onEndEdit(value);
end)
self:addTouchCallBack(self.inputClickHandler, self);
self.component = self._inputComponent.textComponent;
end


function InputLabel:active()
if self._inputComponent ~= nil then
self._inputComponent:ActivateInputField();
end
end


function InputLabel:deactive()
if self._inputComponent ~= nil then
self._inputComponent:DeactivateInputField();
end
end



function InputLabel:isActive()
if self._inputComponent ~= nil then
return self._inputComponent.isFocused;
end
return false;
end

function InputLabel:onValueChanged(value)
if self._changeCallback ~= nil then
self._changeCallback(self._changeTarget,value);
end
end

function InputLabel:onEndEdit(value)

self._isInputing = false;
if self._endCallback ~= nil then
self._endCallback(self._endTarget,value,self);
end
end


function InputLabel:inputClickHandler()
if self._isInputing == true then
return;
end

self._isInputing = self:isActive();
if self._activeCallback ~= nil then
self._activeCallback(self._activeTarget, self);
end
end

function InputLabel:setString(str)
self._inputComponent.text = str;
end
function InputLabel:getString()
return self._inputComponent.text;
end
function InputLabel:setSize(width,height,isForce,isImmediately)
InputLabel.super.setSize(self,width,height,isForce,isImmediately);
local textWidth = self.component:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta.x;
local textHeight = self.component:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta.y;
if width ~= nil and width > 0 and width ~= textWidth then
textWidth = width;
end
if height ~= nil and height > 0 and height ~= textHeight then
textHeight = height;
end
self.component:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = globalManager.poolManager:createVector2(textWidth,textHeight);
end


function InputLabel:setInteractable(value)
self._inputComponent.interactable = value;
end




function InputLabel:setLineType(type)
self._inputComponent.lineType = type;
end

function InputLabel:setMaxLength(limit)
self._inputComponent.characterLimit = limit;
end


function InputLabel:setKeyboardType(type)
self._inputComponent.keyboardType = type;
end





function InputLabel:setContentType(type)
self._inputComponent.contentType = type;
end


function InputLabel:setValueChangedCB(callback,target)
self._changeCallback = callback;
self._changeTarget = target;
end


function InputLabel:setEndEditCB(callback,target)
self._endCallback = callback;
self._endTarget = target;
end


function InputLabel:setActiveCB(callback,target)
self._activeCallback = callback;
self._activeTarget = target;
end



function InputLabel:setDefauleStr(value,color)
color = color or globalConst.colorConst.gray;
if self._defaultStrLabel == nil then
self._defaultStrLabel = globalManager.kCreator:createLabel(FUCK38U);
self._defaultStrLabel:setPosition(0,0);
self._defaultStrLabel:setPivot(globalManager.kCreator.pivotPoint1);
self._defaultStrLabel:setAlign(globalConst.uiConst.anchorType.UpperLeft);
self._defaultStrLabel:setFontSize(self.component.fontSize);
self._inputComponent.placeholder = self._defaultStrLabel.component;
self:addNode(self._defaultStrLabel);
end
self._defaultStrLabel:setColor(color);
self._defaultStrLabel:setString(value);
self._defaultStrLabel:setSizeFitter(self:getSize().x,0);
end

function InputLabel:setTouchEnabled(v)
local component = self.go:GetComponent(typeof(UnityEngine.UI.Text));
if(component == nil or (self._touchEnabled == v and component.raycastTarget == v) or self.is3D == true)then
return;
end
self._touchEnabled = v;
component.raycastTarget = v;
InputLabel.super.setTouchEnabled(self, v);
end

function InputLabel:dispose()
self._inputComponent.placeholder = nil;
self._inputComponent = nil;
self._changeCallback = nil;
self._changeTarget = nil;
self._endCallback = nil;
self._endTarget = nil;
self._activeCallback = nil;
self._activeTarget = nil;
if self._defaultStrLabel ~= nil then
self._defaultStrLabel:dispose();
self._defaultStrLabel = nil;
end
InputLabel.super.dispose(self);
end
ListView = class(FUCK39U,Node);

function ListView:ctor()
self._viewRect = nil;
self._container = nil;
self._scrollRect = nil;
self._contentSize = nil;
self._padding = {top = 0, right = 0, bottom = 0, left = 0};
self._margin = 0;
self._itemList = {};
self._forceCenter = false;
self._jumpItemCb = nil;
self._jumpItemTarget = nil;
self._endGap = 0;
ListView.super.ctor(self);
end

function ListView:createComponent()
self._container = self.go.transform:Find(FUCK40U);
self.component = self.go:GetComponent(typeof(UIScrollContent));
self._scrollRect = self.go:GetComponent(typeof(UnityEngine.UI.ScrollRect));

local masks = self.go:GetComponentsInChildren(typeof(UnityEngine.UI.Mask), true);
if masks ~= nil and masks.Length > 0 then
self._viewRect = masks[0].transform;
end
self:setVertical(true);
end


function ListView:setPadding(top, right, bottom, left)
self._padding.top = top or 0;
self._padding.right = right or 0;
self._padding.bottom = bottom or 0;
self._padding.left = left or 0;
self:refresh();
end

function ListView:setPositionChangeType(scrollPosChangeType)










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

local item = self._itemList[1];
if item ~= nil then

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

self:scrollToPos(destx);
end
end

elseif not self._scrollRect.horizontal and self._scrollRect.vertical then

local item = self._itemList[1];
if item ~= nil then

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

self:scrollToPos(destY);
end
end

end

if self._jumpItemCb ~= nil and self._jumpItemTarget ~= nil and selectIndex >= 0 then
self._jumpItemCb(self._jumpItemTarget, selectIndex + 1);
end
end

end


function ListView:setMargin(margin)
self._margin = margin or 0;
self:refresh();
end


function ListView:scrollToTop()
self:stopMovement();
self._container.anchoredPosition = Vector2.zero;
end


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


function ListView:setViewPortSize(width,height)
self._viewRect.sizeDelta = globalManager.poolManager:createVector2(width,height);
if self._listParentNode ~= nil then
self._listParentNode.sizeDelta = globalManager.poolManager:createVector2(width,height);
end
end


function ListView:pushBackItem(item)
item:setParent(self._container);
table.insert(self._itemList,item);
self:refresh();
end

function ListView:insertItem(item,index)
item:setParent(self._container);
table.insert(self._itemList,index,item);
self:refresh();
end

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
ScrollView = class(FUCK41U,Node);

function ScrollView:ctor()
self._viewRect = nil;
self._container = nil;
self._scrollRect = nil;
self._contentSize = nil;
self._viewPortSize = nil;
self._uiScrollContent = nil;
self._itemWidth = 40;
self._itemHeight = 40;
self._padding = {top = 0, right = 0, bottom = 0, left = 0};
self._gap = {gapW = 0, gapH = 0};
self._rcCount = 1;
self._perFrameCount = 12;
self._itemList = {};
self._waittingList = {};
self._getItemFunc = nil;
self._getIdFunc = nil;
self._getItemLenFunc = nil;
self._cbTarget = nil;
self._allCount = 0;
self._idexIsSetPos = {};

self._lastStartIndex = 0;
self._lastEndIndex = 0;
self._hasSetFormat = false;
self._listParentNode = nil;
ScrollView.super.ctor(self);
end

function ScrollView:createComponent()
self._container = self.go.transform:Find(FUCK42U);
self._scrollRect = self.go:GetComponent(typeof(UnityEngine.UI.ScrollRect));

local scrollContents = self.go:GetComponentsInChildren(typeof(UIScrollContent),true);
if scrollContents ~= nil and scrollContents.Length > 0 then
self._uiScrollContent = scrollContents[0];

self._uiScrollContent.onPositionChange = function() self:refresh(false) end
end

local masks = self.go:GetComponentsInChildren(typeof(UnityEngine.UI.Mask), true);
if masks ~= nil and masks.Length > 0 then
self._viewRect = masks[0].transform;
end
self:setVertical(true);


end


function ScrollView:setPadding(top, right, bottom, left)
self._padding.top = top or 0;
self._padding.right = right or 0;
self._padding.bottom = bottom or 0;
self._padding.left = left or 0;
self:refresh();
end


function ScrollView:setGap(gapW, gapH)
self._gap.gapW = gapW or 0;
self._gap.gapH = gapH or 0;
self:refresh();
end


function ScrollView:scrollToTop()
self:stopMovement();
self._container.anchoredPosition = Vector2.zero;
end


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


function ScrollView:setCallBacks(getItemFunc,getIdFunc,getLenFunc,cbTarget)
self._getItemFunc = getItemFunc;
self._getIdFunc = getIdFunc;
self._getItemLenFunc = getLenFunc;
self._cbTarget = cbTarget;
end


function ScrollView:setFormat(rcCount,itemW,itemH,perCount)
if rcCount ~= nil and rcCount > 0 then self._rcCount = rcCount; end
if itemW ~= nil and itemW > 0 then self._itemWidth = itemW; end
if itemH ~= nil and itemH > 0 then self._itemHeight = itemH; end
if perCount ~= nil and perCount > 0 then self._perFrameCount = perCount; end
self._hasSetFormat = true;
self:refresh();
end


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

if #self._waittingList <= 0 then return; end
globalManager.tickManager:addTick(self.mainTick,self);
end


function ScrollView:updateWaittingList(force)
if force == nil then force = true; end
local curPos = self._container.anchoredPosition;
local startIndex = 0;
local endIndex = 0;
local contentW = self:getContentSize().x;
local contentH = self:getContentSize().y;
local viewW = self._viewRect.sizeDelta.x;
local viewH = self._viewRect.sizeDelta.y;


startIndex = math.floor((curPos.y - self._padding.top) / (self._itemHeight + self._gap.gapW)) * self._rcCount;
startIndex = math.max(startIndex,1);
endIndex = (math.ceil(viewH / (self._itemHeight + self._gap.gapH))+1) * self._rcCount + startIndex;
endIndex = math.min(endIndex,self._allCount + 1);
print(FUCK43U,startIndex,endIndex,curPos.y);

if self._lastStartIndex == startIndex and self._lastEndIndex == endIndex then return;end

self._lastStartIndex = startIndex;
self._lastEndIndex = endIndex;


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

item:setPosition(x,-y,true,true);
end

function ScrollView:mainTick()

if #self._waittingList <= 0 then
globalManager.tickManager:removeTick(self.mainTick,self);
return;
end
local tmpLen = math.min(#self._waittingList,self._perFrameCount);

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


function ScrollView:updateContentSize()

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

HotAreaNode = class(FUCK44U,Node)

function HotAreaNode:ctor()
HotAreaNode.super.ctor(self);
end


function HotAreaNode:setObject(object)
HotAreaNode.super.setObject(self,object);
if object ~= nil then
self.component = object:AddComponent(typeof(UnityEngine.UI.Image));
self.component.color = {r=255,g=255,b=255,a=0};
end
end
GlobalData = class(FUCK45U);

function GlobalData:ctor()
self.USE_POOL = true;
self.uiPrefabs = nil;
self.defaultFont = nil;
self.commonItemPrefabs = nil;

self.systemDateInfo = SystemDateInfo:new();

self.cardInfo = CardInfo:new();
self.cardServerInfo = CardServerInfo:new();
end

function GlobalData:init()

end

function GlobalData:clearAllData()
self.cardInfo:clearAllData();
self.cardServerInfo:clearAllData();
end
UIManager = class(FUCK46U);

function UIManager:ctor()
self.PANEL_WIDTH = 1136;
self.PANEL_HEIGHT = 640;

self.canvas = nil;
self.canvasTransform = nil;

self.mainLayer = nil;
self.mainTransform = nil;

self.canvasScale = self:getCanvasScale();
self.canvas_width = 0;
self.canvas_height = 0;
self.canvasWHScale = nil;

self._tmpVector2 = Vector2.zero;
end

function UIManager:init()
self:createEventSystem();
self:createCanvas();
self:createCanvasLayer();
end

function UIManager:createEventSystem()
local go = UnityEngine.GameObject(FUCK47U);
UnityEngine.Object.DontDestroyOnLoad(go);
self.eventSystem = go:AddComponent(typeof(UnityEngine.EventSystems.EventSystem));
self.eventSystem.sendNavigationEvents = false;
self.eventSystem.pixelDragThreshold = 15;
go:AddComponent(typeof(UnityEngine.EventSystems.StandaloneInputModule));
end

function UIManager:createCanvas()
local go = self:newCanvas(FUCK48U,globalManager.cameraManager.uiCamera,300,-100,globalConst.layerConst.UI,1);
UnityEngine.Object.DontDestroyOnLoad(go);
self.canvasTransform = go:GetComponent(FUCK49U);
self.canvas = go;
end

function UIManager:createCanvasLayer()
self.mainLayer = self:createLayer(self.canvasTransform, FUCK50U, 1000);
self.mainTransform = self.mainLayer.transform;
self.mainLayer:setLayer(globalConst.layerConst.UI);
end


function UIManager:newCanvas(name,camera,planeDistance,sortingOrder,layer,index)
local go = UnityEngine.GameObject(name);
local canvas = go:AddComponent(typeof(UnityEngine.Canvas));
canvas.renderMode = UnityEngine.RenderMode.ScreenSpaceCamera;
canvas.worldCamera = camera;
canvas.planeDistance = planeDistance;

canvas.pixelPerfect = true;
canvas.scaleFactor = self.canvasScale;
canvas.sortingOrder = sortingOrder;

local scaler = go:AddComponent(typeof(UnityEngine.UI.CanvasScaler));
scaler.uiScaleMode = UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize;
self._tmpVector2:Set(self.PANEL_WIDTH, self.PANEL_HEIGHT);
scaler.referenceResolution = self._tmpVector2;
local canvasTransform = go:GetComponent(FUCK51U);
if index == 1 then
self.canvas_width = tonumber(canvasTransform.sizeDelta.x);
self.canvas_height = tonumber(canvasTransform.sizeDelta.y);
self.canvasWHScale = self.canvas_width / self.canvas_height;
print(FUCK52U,self.canvas_width,FUCK53U,self.canvas_height);
end

if self.canvas_width > 0 and self.canvas_width / self.canvas_height >= self.PANEL_WIDTH / self.PANEL_HEIGHT then
scaler.matchWidthOrHeight = 1;
else
scaler.matchWidthOrHeight = 0;
end

go:AddComponent(typeof(UnityEngine.UI.GraphicRaycaster));
go.layer = layer;
return go;
end

function UIManager:createLayer(parent, name, zPosition)
local node = globalManager.kCreator:createNode(name);
node.transform:SetParent(parent, false);
node.transform.pivot = Vector2(0,1);
node.transform.anchorMin = Vector2(0,1);
node.transform.anchorMax = Vector2(0,1);
node.transform.offsetMin = Vector2.zero;
node.transform.offsetMax = Vector2.zero;
node.transform.sizeDelta = Vector2(self.canvas_width, self.canvas_height);
node.transform.anchoredPosition3D = Vector3(0, 0, zPosition);
return node;
end

function UIManager:getCanvasScale()
local scaleWidth = UnityEngine.Screen.width / self.PANEL_WIDTH;
local scaleHeight = UnityEngine.Screen.height / self.PANEL_HEIGHT;
local scaleValue = scaleWidth < scaleHeight and scaleWidth or scaleHeight;
return scaleValue;
end
TickManager = class(FUCK54U);

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

self._ticks = {};
end
GlobalManager = class(FUCK55U);

function GlobalManager:ctor()
self.kCreator = nil;
self.uiManager = nil;
self.poolManager = nil;
self.tickManager = nil;
self.pathManager = nil;
self.loaderManager = nil;
self.cameraManager = nil;
self.triggerManager = nil;
self.gameEventDispatcher = nil;

self.spriteSheetList = nil;
end

function GlobalManager:init()

self.kCreator = KCreator:new();
self.tickManager = TickManager:new();
self.poolManager = PoolManager:new();
self.pathManager = PathManager:new();
self.loaderManager = LoaderManager:new();
self.templateParser = TemplateParser:new();

self.gameEventDispatcher = EventDispatcher:new();

self.uiManager = UIManager:new();
self.cameraManager = CameraManager:new();
self.triggerManager = TriggerManager:new();
self.spriteSheetList = SpriteSheetList:new();

self.cameraManager:init();
self.uiManager:init();
end
CameraManager = class(FUCK56U);

function CameraManager:ctor()
self.uiCamera = nil;

self._tmpVector3 = nil;
end

function CameraManager:init()
self._tmpVector3 = Vector3.zero;

local uiGo = UnityEngine.GameObject(FUCK57U);
UnityEngine.Object.DontDestroyOnLoad(uiGo);
self.uiCamera = uiGo:AddComponent(typeof(UnityEngine.Camera));
self.uiCamera.clearFlags = UnityEngine.CameraClearFlags.Depth;
self.uiCamera.orthographic = true;
self.uiCamera.cullingMask = globalConst.layerConst.UIMask;
self.uiCamera.allowHDR = false;
self.uiCamera.useOcclusionCulling = false;
self.uiCamera.allowMSAA = false;
self.uiCamera.depth = 3;
self._tmpVector3:Set(1000, 1000, 1000);
self.uiTransform = uiGo.transform;
self.uiTransform.position = self._tmpVector3;
end

function CameraManager:restart()
GameObject.Destroy(self.uiCamera.gameObject);
end
GameConfig = class(FUCK58U);

function GameConfig:ctor()

end

function GameConfig:isWin()
return not self:isAndroid() and not self:isIOS();
end

function GameConfig:isAndroid()
return UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android;
end

function GameConfig:isIOS()
return UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer;
end

function GameConfig:getResFoldPath()
do return UnityEngine.Application.streamingAssetsPath; end

end
StartController = class(FUCK59U);

function StartController:startLoad()
self.mubanTime = 0;



print(FUCK60U,UnityEngine.Application.persistentDataPath);

self:loadTemplate();
end

function StartController:loadTemplate()
if(self._templateComplete)then return; end
print(FUCK61U);
globalManager.loaderManager:loadBytes(FUCK62U,self.templateLoadComplete,self);
end
function StartController:templateLoadComplete(abName,assetName,bytes)
if bytes ~= nil then
print(FUCK63U);
self.mubanTime = os.clock();
globalManager.templateParser:start(bytes, self.templateParseComplete, self);
end
end

function StartController:templateParseComplete()
print(FUCK64U);
print(FUCK65U,os.clock() - self.mubanTime);
self._templateComplete = true;
self:loadShaders();
end

function StartController:loadShaders()
globalManager.loaderManager:loadAsset(FUCK66U,nil,self.loadShadersComplete,self);
end

function StartController:loadShadersComplete(abName,assetName,abContent)
globalConst.shaderType:init(abContent);

globalManager.loaderManager:loadAsset(FUCK67U,FUCK68U,self.loadFontComplete,self);
end

function StartController:loadFontComplete(abName,assetName,abContent)
globalData.defaultFont = abContent:LoadAsset(assetName);

globalManager.loaderManager:loadAsset(globalManager.pathManager:getCommonUIPath(),nil,self.loadUICommonComplete,self);
end

function StartController:loadUICommonComplete(abName,assetName,abContent)
globalData.uiPrefabs = parseABContent(abContent);

globalManager.loaderManager:loadAsset(globalManager.pathManager:getCommonItemPrefabPath(),nil,self.loadCommonItemUIComplete,self);
end

function StartController:loadCommonItemUIComplete(abName,assetName,abContent)
globalData.commonItemPrefabs = parseABContent(abContent);

self:startGame();
end

function StartController:startGame()
print(FUCK69U);

if self._gameScene == nil then
self._gameScene = GameScene:new();

end


















end

function StartController:createItemCb(index)

return globalManager.kCreator:createImage();
end

function StartController:getItemIdCb(index)
return index;
end

function StartController:getItemLenCb(index)
return 10;
end

function StartController:btnClickHandler(sender)
print(FUCK70U);
end
AssetLoader = class(FUCK71U);

function AssetLoader:ctor(abName)
self.text = nil;
self.bytes = nil;
self.texture = nil;

self.count = 0;

self.abContent = nil;


self.loadType = 0;

self._cbs = {};
self.abName = abName;

self.loadState = 0;
end

function AssetLoader:doLoad()
if(self.loadState == 0)then
self.loadState = 1;
StartCoroutine(function() self:__load(); end);
end
end

function AssetLoader:__load()
local download = nil;
local resPath = gameConfig:getResFoldPath()..FUCK72U..self.abName;
print(FUCK73U,resPath);
if self.loadType == 0 then
download = UnityEngine.AssetBundle.LoadFromFileAsync(resPath);
else
download = UnityEngine.WWW(resPath);
end

Yield(download);
if(self.loadType ~= 0 and download.error ~= "" and download.error ~= nil)then
print(FUCK74U,download.error,resPath);
else
if self.loadType == 0 then
self.abContent = download.assetBundle;
elseif self.loadType == 1 then
self.text = download.text;
elseif self.loadType == 2 then
self.bytes = download.bytes;
elseif self.loadType == 3 then
self.texture = download.texture;
end
self:loadComplete();
end
if self.loadType ~= 0 then
download:Dispose();
end
download = nil;
end

function AssetLoader:setLoadType(loadType)
self.loadType = loadType;
end


function AssetLoader:addCB(callback,target,assetName)
local index = self:hasCB(callback,target);
if(index == -1)then
local qd = globalManager.poolManager:createQuoteData();
qd:init(callback,target);
qd.params = assetName;
table.insert(self._cbs,qd);
if(self.loadState == 2)then
self:doCallBack(qd);
end
else
print(FUCK75U);
end
end

function AssetLoader:removeCB(callback,target)
local index = self:hasCB(callback,target);
if(index > -1)then
local qd = table.remove(self._cbs,index);
qd:dispose();
end
end

function AssetLoader:hasCB(callback,target)
local len = #self._cbs;
local qd = nil;
for i = 1,len,1 do
qd = self._cbs[i];
if(qd.callback == callback and qd.target == target)then
return i;
end
end
return -1;
end

function AssetLoader:loadComplete()
self.loadState = 2;
local len = #self._cbs;
for i = 1,len,1 do
local qd = self._cbs[i];
self:doCallBack(qd);
end
end

function AssetLoader:doCallBack(qd)
if self.loadType == 0 then
local assetName = qd.params;
print(FUCK76U,assetName);
if assetName ~= nil then
local asset =  self.abContent:LoadAsset(assetName);
qd.callback(qd.target,self.abName,qd.params,self.abContent,asset);
else
qd.callback(qd.target,self.abName,qd.params,self.abContent);
end
elseif self.loadType == 1 then
qd.callback(qd.target,self.abName,qd.params,self.text);
elseif self.loadType == 2 then
qd.callback(qd.target,self.abName,qd.params,self.bytes);
elseif self.loadType == 3 then
qd.callback(qd.target,self.abName,qd.params,self.texture);
end

end

function AssetLoader:isCanRemove()
return #self._cbs <= 0;
end

function AssetLoader:dispose()
self._cbs = nil;
self.text = nil;
self.bytes = nil;
self.texture = nil;
self.abContent = nil;
end
ColorConst = class(FUCK77U)

function ColorConst:ctor()
self.white = clone(UnityEngine.Color.white);
self.black = clone(UnityEngine.Color.black);
self.clear = clone(UnityEngine.Color.clear);
self.gray = clone(UnityEngine.Color.gray);
self.green = clone(UnityEngine.Color.green);
self.blue = clone(UnityEngine.Color.blue);
self.empty = Color(0, 0, 0, 0);

self.cardSelectColor = self:newColor(132,124,124);


self.titleColor = self:newColor(246,255,210);

self.countWhite = self:newColor(240,245,222);

self.btnColor1 = self:newColor(150,86,12);

self.btnColor2 = self:newColor(79,100,31);


self.bright_firstColor = self:newColor(67,85,81);
self.bright_secondColor = self:newColor(108,124,120);
self.bright_green = self:newColor(105,168,43);
self.bright_blue = self:newColor(78,145,255);
self.bright_purple = self:newColor(211,90,219);
self.bright_orange = self:newColor(255,159,9);
self.bright_red = self:newColor(251,86,87);

self.bright_firstColorStr = FUCK78U;
self.bright_secondColorStr = FUCK79U;
self.bright_greenStr = FUCK80U;
self.bright_blueStr = FUCK81U;
self.bright_purpleStr = FUCK82U;
self.bright_orangeStr = FUCK83U;
self.bright_redStr = FUCK84U;

self.dark_firstColor = self:newColor(230,237,203);
self.dark_secondColor = self:newColor(182,205,140);
self.dark_green = self:newColor(145,239,90);
self.dark_blue = self:newColor(89,183,255);
self.dark_purple = self:newColor(234,82,252);
self.dark_orange = self:newColor(251,184,40)
self.dark_red = self:newColor(255,84,78);

self.dark_firstColorStr = FUCK85U;
self.dark_secondColorStr = FUCK86U;
self.dark_greenStr = FUCK87U;
self.dark_blueStr = FUCK88U;
self.dark_purpleStr = FUCK89U;
self.dark_orangeStr = FUCK90U;
self.dark_redStr = FUCK91U;

self.qualityColorList = {self.bright_green,self.bright_blue,self.bright_purple,self.bright_purple,self.bright_orange,self.bright_orange,self.bright_red,self.bright_red};
self.qualityColorStrList = {self.bright_greenStr,self.bright_blueStr,self.bright_purpleStr,self.bright_purpleStr,self.bright_orangeStr,self.bright_orangeStr,self.bright_redStr,self.bright_redStr};

self.qualityColorList2 = {self.dark_green,self.dark_blue,self.dark_purple,self.dark_purple,self.dark_orange,self.dark_orange,self.dark_red,self.dark_red};
self.qualityColorStrList2 = {self.dark_greenStr,self.dark_blueStr,self.dark_purpleStr,self.dark_purpleStr,self.dark_orangeStr,self.dark_orangeStr,self.dark_redStr,self.dark_redStr};
end

function ColorConst:newColor(r,g,b)
local color = UnityEngine.Color();
color.r = r/255;
color.g = g/255;
color.b = b/255;
color.a = 1;
return color;
end

function ColorConst:getColorByQuality(quality, isBlack)
if(quality > 8)then return isBlack and self.dark_red or self.bright_red; end
return isBlack and self.qualityColorList2[quality] or self.qualityColorList[quality];
end

function ColorConst:getColorStrByQuality(quality)
if(quality > 8)then return self.redStr; end
return self.qualityColorStrList[quality];
end

function ColorConst:getColorNameByQuality(name,quality)
local colorStr = self:getColorStrByQuality(quality);
return self:getColorStr(colorStr,name);
end


function ColorConst:getColorStr(color,str)
return KYstringFormat(FUCK92U,color,str);
end
EventType = class(FUCK93U);

function EventType:ctor()
self.card_out = 1000;
self.deal_cards = 1001;
self.select_card_handle = 1002;
end
GobalConst = class(FUCK94U);

function GobalConst:ctor()
self.layerConst = nil;
self.colorConst = nil;
self.shaderType = nil;
self.triggerType = nil;
self.eventType = nil;

self.landTemplateList = nil;
self.pokerHandTemplateList = nil;

self.handlePattern = FUCK95U;
end

function GobalConst:init()
self.layerConst = LayerConst:new();
self.colorConst = ColorConst:new();
self.triggerType = TriggerType:new();
self.shaderType = ShaderType:new();
self.eventType = EventType:new();

self.landTemplateList = LandTemplateList:new();
self.pokerHandTemplateList = PokerHandTemplateList:new();
end
LayerConst = class(FUCK96U);

function LayerConst:ctor()
self.Default = LayerMask.NameToLayer(FUCK97U);
self.TransparentFX = LayerMask.NameToLayer(FUCK98U);
self.IgnoreRaycast = LayerMask.NameToLayer(FUCK99U);
self.Water = LayerMask.NameToLayer(FUCK100U);
self.UI = LayerMask.NameToLayer(FUCK101U);

self.DefaultMask = bit.lshift(1, self.Default);
self.TransparentFXMask = bit.lshift(1, self.TransparentFX);
self.IgnoreRaycastMask = bit.lshift(1, self.IgnoreRaycast);
self.WaterMask = bit.lshift(1, self.Water);
self.UIMask = bit.lshift(1, self.UI);
end
SystemDateInfo = class(FUCK102U);


function SystemDateInfo:ctor()

self.timeZone = 0;

self.timeZoneSecond = 0;

self._serverDateTime = 0;

self._clientDateTime = 0;

self._startTime = 0;

self.secondsOfDay = 86400;
self.millSecOfDay = 86400000;
self.FIVE_CLOCK_TIME = 18000;

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

local runTime = Time.realtimeSinceStartup * 1000;
self._clientDateTime = self._serverDateTime + (os.clock() * 1000 - self._startTime);
end


function SystemDateInfo:getSystemTime()
return self._clientDateTime;
end

function SystemDateInfo:getSystemTimeSec()
return math.floor(self._clientDateTime * 0.001);
end

TriggerInfo = class(FUCK103U);

function TriggerInfo:ctor()
self.params = {};
self.type = 0;
self.action = 0;
self.group = 0;
self.descript = "";
end


function TriggerInfo:init(data)
self.type = data:readByte();
self.action = data:readShort();
self.group = data:readByte();
self.descript = data:readString();
self.params = {};
for i=1,4 do
table.insert(self.params, data:readInt());
end
end


function TriggerInfo:initWithString(str)
local list = string.split(str,FUCK104U);
if #list < 8 then
print(FUCK105U..str);
return;
end
self.type = tonumber(list[1]);
self.action = tonumber(list[2]);
self.group = tonumber(list[3]);
self.descript = tostring(list[4]);
self.params = {};
table.insert(self.params, tonumber(list[5]));
table.insert(self.params, tonumber(list[6]));
table.insert(self.params, tonumber(list[7]));
table.insert(self.params, tonumber(list[8]));
end
TriggerType = class(FUCK106U);

function TriggerType:ctor()

self.imageGroup = 1;

self.clickTxtGroup = 2;

self.underlineGroup = 3;
end
CardInfo = class(FUCK107U,EventDispatcher);

function CardInfo:ctor()
CardInfo.super.ctor(self);

self.mySeat = 1;
self.selectCards = nil;

self.tipCardInfoList = nil;
self.curTipCardInfoIdx = nil;

self.curSelfCardInfoList = nil;
end

function CardInfo:setCurSelfCardInfoList(cardInfoList)
self.curSelfCardInfoList = cardInfoList;
end

function CardInfo:setSelectCards(cardItemInfo,isSelect)
cardItemInfo.isSelect = isSelect;
if isSelect then
if self.selectCards == nil then
self.selectCards = {};
end
table.insert(self.selectCards,cardItemInfo);
else
if self.selectCards ~= nil then
local index = arrayIndexOf(self.selectCards,cardItemInfo);
table.remove(self.selectCards,index);
end
end
self:dispatchEvent(globalConst.eventType.select_card_handle,cardItemInfo);
end


function CardInfo:checkSelfCardsByOutCards()
local curOutCards = globalData.cardServerInfo:getCurOutCards(self.mySeat);
if curOutCards == nil then
print(FUCK108U)
return;
end

if self.tipCardInfoList ~= nil then
print(FUCK109U,#self.curSelfCardInfoList);
self.curTipCardInfoIdx = self.curTipCardInfoIdx + 1;
if self.curTipCardInfoIdx > #self.tipCardInfoList then
self.curTipCardInfoIdx = 1;
end
self:updateCurTipCardInfo();
return;
end


self.tipCardInfoList = globalData.cardServerInfo:checkAllCards(self.curSelfCardInfoList,curOutCards);

print(FUCK110U,#self.tipCardInfoList);
if #self.tipCardInfoList > 0 then
self.curTipCardInfoIdx = 1;
self:updateCurTipCardInfo();

else
self.tipCardInfoList = nil;
print(FUCK111U);
end

end

function CardInfo:updateCurTipCardInfo()
self:clearAllSelectCards();
local curTipCardInfoList = self.tipCardInfoList[self.curTipCardInfoIdx];
for i=1,#curTipCardInfoList do
self:setSelectCards(curTipCardInfoList[i],true);
end
end

function CardInfo:checkSelectCards()
if self.selectCards ~= nil then
local typeList = {};
for i=1,#self.selectCards do
table.insert(typeList,self.selectCards[i].type);
end
local handType = globalConst.pokerHandTemplateList:getHandTpye(typeList);
local handTemp = globalConst.pokerHandTemplateList:getInfo(handType);
if handTemp ~= nil then
print(FUCK112U,handTemp.type,handTemp.descript);
return true;
else
local content = ""
for i=1,#typeList do
content = content .. FUCK113U .. typeList[i];
end
print(FUCK114U..content);
return false;
end
end
print(FUCK115U);
return false;
end

function CardInfo:clearAllSelectCards()
if self.selectCards ~= nil then
for i=1,#self.selectCards do
self.selectCards[i].isSelect = false;
self:dispatchEvent(globalConst.eventType.select_card_handle,self.selectCards[i]);
end
self.selectCards = nil;
end
end

function CardInfo:clearTipInfos()
self.tipCardInfoList = nil;
self.curTipCardInfoIdx = nil;
end

function CardInfo:clearSelectCards()
self.selectCards = nil;
end

function CardInfo:clearCards()
self.tipCardInfoList = nil;
self:clearTipInfos();
self:clearSelectCards();
end


function CardInfo:clearAllData()
self.curCardIds = nil;
self.tipCardInfoList = nil;
self.curTipCardInfoIdx = nil;
self.curSelfCardInfoList = nil;
end
CardItemInfo = class(FUCK116U);

function CardItemInfo:ctor()
self.id = 0;
self.type = 0;
self.color = 0;

self.isSelect = false;
end

function CardItemInfo:setId(id)
self.id = id;
self.template = globalConst.landTemplateList:getInfo(self.id);
self.type = self.template.type;
self.color = self.template.color;
self.size = self.template.size;
end

function CardItemInfo:dispose()

end
CardPlayerInfo = class(FUCK117U);

function CardPlayerInfo:ctor(seat)
self.seat = seat;

self.gameStatus = 0;
self.isAutoOutCard = true;
self.curCardInfoList = nil;
end

function CardPlayerInfo:setCards(curCardInfoList)
function sortFunc(info1,info2)
if info1.size ~= info2.size then
return info1.size > info2.size;
else
return info1.color > info2.color;
end
end
self.curCardInfoList = curCardInfoList;

table.sort(self.curCardInfoList,sortFunc);
end

function CardPlayerInfo:getCurCardInfoList()
return self.curCardInfoList;
end


function CardPlayerInfo:doCurCardsPassively(outcards)
local list = globalData.cardServerInfo:checkAllCards(self.curCardInfoList,outcards);
print(FUCK118U,seat,#list);
if #list > 0 then
if self.isAutoOutCard then
globalData.cardServerInfo:setCurOutCards(self.seat,list[1]);
end
else
self:doNoOutCards();
print(FUCK119U..self.seat..FUCK120U);
end
end


function CardPlayerInfo:doCurCardsPositively()

end


function CardPlayerInfo:doNoOutCards()
globalData.cardServerInfo:doNextTurnSeat();
end


function CardPlayerInfo:checkHandCards()
local curCards = {};

for i=1,#self.curCardInfoList do
table.insert(curCards,self.curCardInfoList[i]);
end


local biggestCards = globalData.cardServerInfo:checkBiggestCard(curCards);
local content = FUCK121U;
for i=1,#biggestCards do
content = content..biggestCards[i].type..FUCK122U;
end
print(content);


local fourCards = globalData.cardServerInfo:checkFourCard(curCards);
local content = FUCK123U;
for i=1,#fourCards do
local list1 = fourCards[i];
for j=1,#list1 do
local index = arrayIndexOf(curCards,list1[j]);
if index ~= -1 then
table.remove(curCards,index);
end
content = content..list1[j].type..FUCK124U;
end
end
print(content);


local lianDuiCards = globalData.cardServerInfo:checkLianDui(curCards);
local content = FUCK125U;
for i=1,#lianDuiCards do
local list1 = lianDuiCards[i];
for j=1,#list1 do
content = content..list1[j].type..FUCK126U;
end
end
print(content);

local shunziCards = globalData.cardServerInfo:checkShunzi(curCards);
local content = FUCK127U;
for i=1,#shunziCards do
local list1 = shunziCards[i];
for j=1,#list1 do
content = content..list1[j].type..FUCK128U;
end
end
print(content);

local threeCards = globalData.cardServerInfo:checkThreeCard(curCards);
local content = FUCK129U;
for i=1,#threeCards do
local list1 = threeCards[i];
for j=1,#list1 do
content = content..list1[j].type..FUCK130U;
end
end
print(content);


local twoCards = globalData.cardServerInfo:checkTwoCard(curCards,true);
local content = FUCK131U;
for i=1,#twoCards do
local list1 = twoCards[i];
for j=1,#list1 do
content = content..list1[j].type..FUCK132U;
end
end
print(content);

local count = #self.curCardInfoList;
local oneCards = globalData.cardServerInfo:checkSingleCard(curCards,nil,true);
local content = FUCK133U;
for i=1,#oneCards do
content = content..oneCards[i].type..FUCK134U;
end
print(content);

end

function CardPlayerInfo:dispose()
self.curCardInfoList = nil;
end
CardServerInfo = class(FUCK135U,EventDispatcher);

function CardServerInfo:ctor()
CardServerInfo.super.ctor(self);
self.curOutCards = nil;
self.curOutCardSeat = nil;

self.curCardIds = nil;

self.curHandCards = nil;

self.specialCards = nil;
self.lastOutTime = nil;

self.cardPlayerInfoList = nil;


self.curSeat = 1;
self.MAX_SEAT = 3;
self.MAX_CARD_COUNT = 54;
self.MAX_HAND_COUNT = 17;
self.LAND_CARD_COUNT = 20;
end

function CardServerInfo:startGame()
self:buildCardIds();
self.curOutCards = {};

end

function CardServerInfo:update()

if self.curOutCardSeat then

if globalData.systemDateInfo:getSystemTime() - self.lastOutTime > 5000 then

if self.turnSeat == self.curOutCardSeat then
self.cardPlayerInfoList[self.turnSeat]:doCurCardsPositively();
else
local lastOutCards = self.curOutCards[self.curOutCardSeat];
if lastOutCards ~= nil then
self.cardPlayerInfoList[self.turnSeat]:doCurCardsPassively(lastOutCards);
end
end
end
end
end

function CardServerInfo:endGame()
globalManager.tickManager:removeTick(self.update,self);
end

function CardServerInfo:buildCardIds()
math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)));
self.curCardIds = {};
for i=1,self.MAX_CARD_COUNT do
self.curCardIds[i] = i;
end

for i=1,#self.curCardIds do
local rand = math.random(1, self.MAX_CARD_COUNT);
local temp = self.curCardIds[i];
self.curCardIds[i] = self.curCardIds[rand];
self.curCardIds[rand] = temp;
end


self.curHandCards = {};
self.curHandCards[1] = {};
self.curHandCards[2] = {};
self.curHandCards[3] = {};
local len = self.MAX_HAND_COUNT*self.MAX_SEAT;
for i=1,len do
if i%3 == 1 then
table.insert(self.curHandCards[1],self.curCardIds[i]);
elseif i%3 == 2 then
table.insert(self.curHandCards[2],self.curCardIds[i]);
elseif i%3 == 0 then
table.insert(self.curHandCards[3],self.curCardIds[i]);
end
end


self.cardPlayerInfoList = {};
for i=1,self.MAX_SEAT do
self.cardPlayerInfoList[i] =  CardPlayerInfo:new(i);
end




for i=1,self.MAX_SEAT do
local ids = self.curHandCards[i];
local curCardInfoList = {};
for j=1,#ids do
local info = CardItemInfo:new();
info:setId(ids[j]);
table.insert(curCardInfoList,info);
end
self.cardPlayerInfoList[i]:setCards(curCardInfoList);
end


self.specialCards = {self.curCardIds[len+1],self.curCardIds[len+2],self.curCardIds[len+3]}

globalData.cardInfo:setCurSelfCardInfoList(self.cardPlayerInfoList[globalData.cardInfo.mySeat]:getCurCardInfoList());
end


function CardServerInfo:doNextTurnSeat()
self.turnSeat = self.turnSeat + 1;
if self.turnSeat > 3 then
self.turnSeat = 1;
end
end

function CardServerInfo:setCurOutCards(seat,outCardItemInfos)
function sortFunc(info1,info2)
if info1.size ~= info2.size then
return info1.size > info2.size;
else
return info1.color > info2.color;
end
end
self.turnSeat = seat;
self.curOutCardSeat = seat;
self.curOutCards[seat] = outCardItemInfos;
table.sort(self.curOutCards[seat],sortFunc);
self.lastOutTime = globalData.systemDateInfo:getSystemTime();

self:dispatchEvent(globalConst.eventType.card_out,seat);

self:doNextTurnSeat();
end

function CardServerInfo:getCurOutCards(seat)
return self.curOutCards[seat];
end

function CardServerInfo:getCurCardInfoList(seat)
return self.cardPlayerInfoList[seat]:getCurCardInfoList();
end


function CardServerInfo:isShunziCards(cardItemInfos)
if #cardItemInfos < 5 then
return false;
end

function sortCardFunc2(info1,info2)
if info1.size ~= info2.size then
return info1.size < info2.size;
else
return info1.color < info2.color;
end
end
local isSuit = true;
table.sort(cardItemInfos,sortCardFunc2);
for i=2,#cardItemInfos do
if cardItemInfos[i].type - cardItemInfos[i-1].type ~= 1 then
if cardItemInfos[i].type ~= globalConst.landTemplateList.ONE_TYPE then
isSuit = false;
break;
end
end
end
return isSuit;
end


function CardServerInfo:getSmallCards(restCardItemInfos,handype,needCount,exceptTypes)

local smallCardItemInfos = nil;

if handype == globalConst.pokerHandTemplateList.ONE_CARD_TYPE then

smallCardItemInfos = self:checkFirstOneCard(restCardItemInfos,needCount,exceptTypes);
elseif handype == globalConst.pokerHandTemplateList.TWO_CARD_TYPE then
smallCardItemInfos = self:checkFirstTwoCard(restCardItemInfos,needCount);
end

return smallCardItemInfos;
end


function CardServerInfo:checkFirstOneCard(cardItemInfoList,needCount,exceptTypes)
local smallCardItemInfos = self:checkOneCard(cardItemInfoList,exceptTypes);
if #smallCardItemInfos > needCount then
local ret = {};
for i=1,needCount do
table.insert(ret,smallCardItemInfos[i]);
end
return ret;
end
return nil;
end


function CardServerInfo:checkOneCard(cardItemInfoList,exceptTypes)
local cardItemInfos = {};
for i=1,#cardItemInfoList do
table.insert(cardItemInfos,cardItemInfoList[i]);
end

function sortCardFunc2(info1,info2)
if info1.size ~= info2.size then
return info1.size < info2.size;
else
return info1.color < info2.color;
end
end
table.sort(cardItemInfos,sortCardFunc2);

local smallCardItemInfos = {};

local otherCardItemInfos = {};

local isFind = false;
local len = #cardItemInfos;
for i=1,len do
if #cardItemInfos == 0 then break; end
local isSuit = true;
local curCheckCardItemInfo = table.remove(cardItemInfos,1);
local curType = curCheckCardItemInfo.type;
local isCanCheck = true;

if exceptTypes ~= nil and arrayIndexOf(exceptTypes,curType) ~= -1 then
isCanCheck = false
end
if isCanCheck then

if curType == globalConst.landTemplateList.BIG_JOKER_TYPE then
local isFind = false;
for j = 1,#cardItemInfos do

if cardItemInfos[j].type == globalConst.landTemplateList.SMALL_JOKER_TYPE  then
isFind = true;
table.remove(cardItemInfos,j);
table.insert(otherCardItemInfos,cardItemInfos[j]);
break;
end
end

if isFind then
table.insert(otherCardItemInfos,curCheckCardItemInfo);
else
table.insert(smallCardItemInfos,curCheckCardItemInfo);
end

elseif curType == globalConst.landTemplateList.SMALL_JOKER_TYPE then
local isFind = false;
for j = 1,#cardItemInfos do

if cardItemInfos[j].type == globalConst.landTemplateList.BIG_JOKER_TYPE  then
isFind = true;
table.remove(cardItemInfos,j);
table.insert(otherCardItemInfos,cardItemInfos[j]);
break;
end
end

if isFind then
table.insert(otherCardItemInfos,curCheckCardItemInfo);
else
table.insert(smallCardItemInfos,curCheckCardItemInfo);
end
else

local sameCardIndexs = {};
for j = 1,#cardItemInfos do
if curType == cardItemInfos[j].type then
table.insert(sameCardIndexs,j);
end
end

if #sameCardIndexs > 0 then
table.insert(otherCardItemInfos,curCheckCardItemInfo);

for j=#sameCardIndexs,1,-1 do
local info = table.remove(cardItemInfos,sameCardIndexs[j]);
table.insert(otherCardItemInfos,info);
end
else

if curCheckCardItemInfo.type == globalConst.landTemplateList.TWO_TYPE then
table.insert(smallCardItemInfos,curCheckCardItemInfo);

else
local isShunzi = false;
if #cardItemInfos > 4 then
local needCheckCards = {};
table.insert(needCheckCards,curCheckCardItemInfo);
for j=1,4 do
table.insert(needCheckCards,cardItemInfos[j]);
end
isShunzi = self:isShunziCards(needCheckCards);
end


if isShunzi then
table.insert(otherCardItemInfos,curCheckCardItemInfo);
for k=1,4 do
local info = table.remove(cardItemInfos,1);
table.insert(otherCardItemInfos,info);
end
else

table.insert(smallCardItemInfos,curCheckCardItemInfo);
end
end
end
end
end
end
table.sort(otherCardItemInfos,sortCardFunc2);

for i=1,#otherCardItemInfos do
table.insert(smallCardItemInfos,otherCardItemInfos[i]);
end
return smallCardItemInfos;
end

function CardServerInfo:checkFirstTwoCard(cardItemInfoList,needCount)
local smallCardItemInfos = self:checkTwoCard(cardItemInfoList);

if smallCardItemInfos ~= nil and #smallCardItemInfos >= needCount then
local ret = {};
for i=1,needCount do
table.insert(ret,smallCardItemInfos[i]);
end
return ret;
end
return nil;
end


function CardServerInfo:checkTwoCard(cardItemInfoList,isLimit)
local cardItemInfos = {};
for i=1,#cardItemInfoList do
table.insert(cardItemInfos,cardItemInfoList[i]);
end

function sortCardFunc2(info1,info2)
if info1.size ~= info2.size then
return info1.size < info2.size;
else
return info1.color < info2.color;
end
end
table.sort(cardItemInfos,sortCardFunc2);

local smallCardItemInfos = {};
local otherCardItemInfos = {};

local len = #cardItemInfos;

local idx = 1;

local selectIdxs = {};
for i=1,len do
if (len - idx + 1) < 2 then break; end
local curCheckCardItemInfo = cardItemInfos[idx];
if curCheckCardItemInfo.type == cardItemInfos[idx+1].type then

if (len - idx + 1) == 2 then
table.insert(smallCardItemInfos,{curCheckCardItemInfo,cardItemInfos[idx+1]});
idx = idx + 1;
elseif (len - idx + 1) > 2 then

if curCheckCardItemInfo.type ~= cardItemInfos[idx+2].type then
table.insert(smallCardItemInfos,{curCheckCardItemInfo,cardItemInfos[idx+1]});
idx = idx + 1;
else
idx = idx + 2;
end
end
end
idx = idx + 1;
end


if isLimit ~= true then
len = #cardItemInfos;
for i=1,len do
if #cardItemInfos < 3 then break; end
local curCheckCardItemInfo = table.remove(cardItemInfos,1);
local sameIndexs = {};
for j=1,#cardItemInfos do
if cardItemInfos[j].type == curCheckCardItemInfo.type then
table.insert(sameIndexs,j);
end
end

if #sameIndexs >= 2 then
if #sameIndexs == 2 then
local sameIndex = sameIndexs[1];
table.insert(smallCardItemInfos,{curCheckCardItemInfo,cardItemInfos[sameIndex]});
end
for j=#sameIndexs,1,-1 do
table.remove(cardItemInfos,sameIndexs[j]);
end
end
end
end
return smallCardItemInfos;
end



function CardServerInfo:checkCardsByHandleType(cardItemInfoList,handype,compareCardTypes)
local list = {};
flag = flag or 1;
if handype == globalConst.pokerHandTemplateList.ONE_CARD_TYPE then
local templist = self:checkOneCard(cardItemInfoList);
if templist ~= nil and compareCardTypes ~= nil then
local compareSize = globalConst.landTemplateList:getInfo(compareCardTypes[1]).size;

for i=1,#templist do

if templist[i].size > compareSize then
table.insert(list,{templist[i]});
end
end
end
return list;
elseif handype == globalConst.pokerHandTemplateList.TWO_CARD_TYPE then
local templist = self:checkTwoCard(cardItemInfoList);
if templist ~= nil and compareCardTypes ~= nil then
local compareSize = globalConst.landTemplateList:getInfo(compareCardTypes[1]).size;

for i=1,#templist do
local curSize = templist[i][1].size;

if curSize > compareSize then
table.insert(list,templist[i]);
end
end
end
return list;
end



local pokerHandTemp = globalConst.pokerHandTemplateList:getInfo(handype);
local exceptCardTypes = pokerHandTemp.exceptPokers;

local checkCardTypes = {};
for i=1,#cardItemInfoList do
table.insert(checkCardTypes,cardItemInfoList[i].type);
end
local len = #cardItemInfoList;



local pokerHandList = pokerHandTemp.pokerHandList;
for i=1,#pokerHandList do
local mainCardTypes = pokerHandList[i];
local tempCardInfoList = {};

if flag == 2 and #list > 0 then
break;
end
local isCanCheck = true;

if compareCardTypes ~= nil then

local size1 = globalConst.landTemplateList:getSizeByType(mainCardTypes[1]);
local size2 = globalConst.landTemplateList:getSizeByType(compareCardTypes[1]);

if size1 <= size2 then
isCanCheck = false;
tempCardInfoList = nil;
end
end
if isCanCheck then
for j=1,#mainCardTypes do
local isFind = false;
local cardType = mainCardTypes[j];




for k=len,1,-1 do

if checkCardTypes[k] == cardType then
if arrayIndexOf(tempCardInfoList,cardItemInfoList[k]) == -1 then
isFind = true;
table.insert(tempCardInfoList,cardItemInfoList[k]);
break;
end
end
end

if not isFind then

tempCardInfoList = nil;
break;
end
end
end

if tempCardInfoList ~= nil then
if pokerHandTemp.otherCount == 0 then
table.insert(list,tempCardInfoList);

else

local restCardItemInfos = {};

for j=len,1,-1 do
if arrayIndexOf(tempCardInfoList,cardItemInfoList[j]) == -1 then
table.insert(restCardItemInfos,cardItemInfoList[j]);
end
end
local handype = pokerHandTemp.otherPokerList[1];
local needCount = pokerHandTemp.otherPokerList[2];
local smallCardItemInfos = self:getSmallCards(restCardItemInfos,handype,needCount,exceptCardTypes[i]);
if smallCardItemInfos ~= nil then

for j=1,#smallCardItemInfos do
table.insert(tempCardInfoList,smallCardItemInfos[j]);
end
table.insert(list,tempCardInfoList);
end
end
end
end

return list;
end

function CardServerInfo:checkAllCards(cardItemInfoList,curOutCards)
local outTypes = {};
for i=1,#curOutCards do
table.insert(outTypes,curOutCards[i].type);
end
local outHandType,outMainTypes = globalConst.pokerHandTemplateList:getHandTpye(outTypes);
print(FUCK136U,outHandType,outMainTypes);

local pokerHandTemp = globalConst.pokerHandTemplateList:getInfo(outHandType);
local pressTypeList = pokerHandTemp.pressTypeList;

local ret = {};
for i=1,#pressTypeList do

if pressTypeList[i] == outHandType then
local list = self:checkCardsByHandleType(cardItemInfoList,pressTypeList[i],outMainTypes);
ret = table.merge(ret,list);
else
local list = self:checkCardsByHandleType(cardItemInfoList,pressTypeList[i]);
ret = table.merge(ret,list);
end
end
return ret;
end


function CardServerInfo:checkSingleCard(cardItemInfoList)

local ret = {};
local len = #cardItemInfoList;
local i = len;
while i > 0 do
local curCheckCardItemInfo = cardItemInfoList[i];
local curType = curCheckCardItemInfo.type;

if curType == globalConst.landTemplateList.BIG_JOKER_TYPE then
local isFind = false;
for j = i - 1,1,-1 do

if cardItemInfoList[j].type == globalConst.landTemplateList.SMALL_JOKER_TYPE  then
isFind = true;
break;
end
end

if not isFind then
table.remove(cardItemInfoList,i);
table.insert(ret,curCheckCardItemInfo);
i = i -1;
end

elseif curType == globalConst.landTemplateList.SMALL_JOKER_TYPE then
local isFind = false;
for j = i-1,1,-1 do

if cardItemInfoList[j].type == globalConst.landTemplateList.BIG_JOKER_TYPE  then
isFind = true;
break;
end
end

if not isFind then
table.remove(cardItemInfoList,i);
table.insert(ret,curCheckCardItemInfo);
i = i -1;
end
else

local sameCardIndexs = {};
for j = i - 1,1,-1 do
if curType == cardItemInfoList[j].type then
table.insert(sameCardIndexs,j);
end
end

if #sameCardIndexs > 0 then

i = i - #sameCardIndexs - 1;
else
table.remove(cardItemInfoList,i);
table.insert(ret,curCheckCardItemInfo);
i = i -1;
end
end
end

return ret;
end


function CardServerInfo:checkLianDui(cardItemInfoList)
local ret = {};
local len = #cardItemInfoList;
local i = len;
while i >= 6 do
local ret1 = {};
local type1 = cardItemInfoList[i].type;
local type2 = cardItemInfoList[i-1].type;
if type1 == type2 then
table.insert(ret1,cardItemInfoList[i]);
table.insert(ret1,cardItemInfoList[i-1]);
local curType = nil;

if type1 == globalConst.landTemplateList.K_TYPE then
curType = globalConst.landTemplateList.ONE_TYPE;
else
curType = type1 + 1;
end

for j = i - 2,1,-1 do
local findList = {};

if curType == globalConst.landTemplateList.TWO_TYPE then
break;
end
for k = j,1,-1 do
if curType == cardItemInfoList[k].type then
table.insert(findList,cardItemInfoList[k]);
end
if #findList == 2 then
break;
end
end
if #findList == 2 then

if curType == globalConst.landTemplateList.K_TYPE then
curType = globalConst.landTemplateList.ONE_TYPE;
else
curType = curType + 1;
end
table.insert(ret1,findList[1]);
table.insert(ret1,findList[2]);
else
break;
end
end
if #ret1 >= 6 then
i = i - #ret1;
table.insert(ret,ret1);
else
i = i - 2;
end
else
i = i - 1;
end
end

for i=1,#ret do
local list = ret[i];
for j=1,#list do
local index = arrayIndexOf(cardItemInfoList,list[j]);
table.remove(cardItemInfoList,index);
end
end

return ret;
end


function CardServerInfo:checkThreeCard(cardItemInfoList)
local ret = {};
local len = #cardItemInfoList;
local i = len;
while i > 3 do
local curCardItemInfo = cardItemInfoList[i];
local curType = curCardItemInfo.type;
local ret1 = {};
local j = 1;
while j < 4 do
local nextCardItemInfo = cardItemInfoList[i-j];
if nextCardItemInfo ~= nil then
if curType == nextCardItemInfo.type then
table.insert(ret1,nextCardItemInfo);
else
break;
end
end
j = j + 1;
end
i = i - #ret1 - 1;

if #ret1 == 2 then
table.insert(ret1,1,curCardItemInfo);
table.insert(ret,ret1);
for j=1,#ret1 do
local index = arrayIndexOf(cardItemInfoList,ret1[j]);
table.remove(cardItemInfoList,index);
end
end
end

return ret;
end


function CardServerInfo:checkShunzi(cardItemInfoList)
local ret = {};
local flagList = {};
local len = #cardItemInfoList;
if len >= 5 then
local i = len;
while i > 4 do
local curType = cardItemInfoList[i].type;
local ret1 = {cardItemInfoList[i]};
for j=i-1,1,-1 do
local nextType = cardItemInfoList[j].type;
if nextType ~= globalConst.landTemplateList.TWO_TYPE then
if (nextType - curType == 1) or (curType == globalConst.landTemplateList.K_TYPE and nextType == globalConst.landTemplateList.ONE_TYPE) then
curType = nextType;
table.insert(ret1,cardItemInfoList[j]);
end
end
j = j - 1;
end
if #ret1 >= 5 then
for j=1,#ret1 do
local index = arrayIndexOf(cardItemInfoList,ret1[j]);
table.remove(cardItemInfoList,index);
end
table.insert(ret,ret1);
i = i - #ret1;
else
i = i - 1;
end
end
end

return ret;
end


function CardServerInfo:checkFourCard(cardItemInfoList)
local ret = {};
local len = #cardItemInfoList;
local i = len;
while i > 0 do
if i < 3 then break; end
local curCardItemInfo = cardItemInfoList[i];
local curType = curCardItemInfo.type;
local ret1 = {};
local j = 1;
while j < 4 do
local nextCardItemInfo = cardItemInfoList[i-j];
if nextCardItemInfo ~= nil then
if curType == nextCardItemInfo.type then
table.insert(ret1,nextCardItemInfo);
else
break;
end
end
j = j + 1;
end
i = i - #ret1 - 1;

if #ret1 == 3 then
for j=0,3 do
table.remove(cardItemInfoList,i-j);
end
table.insert(ret1,1,curCardItemInfo);
table.insert(ret,ret1);
end
end

return ret;
end


function CardServerInfo:checkBiggestCard(cardItemInfoList)
local ret = {};
local len = #cardItemInfoList;
if len >= 2 then
local ret1 = {};
local i = len;
while i > 0 do
if cardItemInfoList[i].type == globalConst.landTemplateList.BIG_JOKER_TYPE or cardItemInfoList[i].type == globalConst.landTemplateList.SMALL_JOKER_TYPE then
table.insert(ret1,cardItemInfoList[i]);
table.remove(cardItemInfoList,i);
end
i = i - 1;
end
if #ret1 == 2 then
ret = ret1;
end
end
return ret;
end

function CardServerInfo:clearAllData()
self.curOutCards = nil;

self.curCardIds = nil;

self.curHandCards = nil;

self.specialCards = nil;
self.cardPlayerInfoList = nil;
end
ShaderType = class(FUCK137U);

function ShaderType:ctor()
self.shaders = {};
end

function ShaderType:init(abContent)
local s = abContent:LoadAllAssets(typeof(UnityEngine.Shader));
local len = s.Length - 1;
local tmps = nil;
local tmpName = nil;
for i = 0,len,1 do
local tmps = string.split(s[i].name,FUCK138U);
if #tmps > 0 then
tmpName = tmps[#tmps];
self.shaders[tmpName] = s[i];

end
end


self.Default_Gray = self.shaders[FUCK139U];
self.PSD2UGUI_SPLIT_ALPHA = self.shaders[FUCK140U];
self.PSD2UGUI_SPLIT_ALPHA_GREY = self.shaders[FUCK141U];
self.UiObj = self.shaders[FUCK142U];
self.UiObj_Mask = self.shaders[FUCK143U];
end
SpriteSheetInfo = class(FUCK144U);

function SpriteSheetInfo:ctor(sheetName)
self.sheetName = sheetName;
self.material = nil;
self.sprites = {};
self.count = 0;
end

function SpriteSheetInfo:init(abContent)
local m = abContent:LoadAllAssets(typeof(UnityEngine.Material));
if(m ~= nil)then
self.material = m[0];
end
local s = abContent:LoadAllAssets(typeof(UnityEngine.Sprite));
local Len = s.Length - 1;
for i = 0,Len,1 do
self.sprites[s[i].name] = s[i];
end
end

function SpriteSheetInfo:getSprite(name)
return self.sprites[name];
end

function SpriteSheetInfo:addCount()
self.count = self.count + 1;
end

function SpriteSheetInfo:reduceCount()
self.count = self.count - 1;
end

function SpriteSheetInfo:isCanDestory()
return self.count <= 0;
end

function SpriteSheetInfo:dispose()
self.sprites = nil;
self.material = nil;
globalManager.loaderManager:destroyAB(self.sheetName);
end
SpriteSheetList = class(FUCK145U);

function SpriteSheetList:ctor()
self.list = {};
self.waitingLoadSheetDic = {};
end

function SpriteSheetList:addSheet(name,abContent)
local sheetInfo = self.list[name];
if(sheetInfo ~= nil)then
return;
end
sheetInfo = SpriteSheetInfo:new(name);
self.list[name] = sheetInfo;
sheetInfo:init(abContent);
end

function SpriteSheetList:loadSprite(abName,spriteName,cb,cbTarget)

local spriteSheetInfo = self.list[abName];
if spriteSheetInfo ~= nil then
local sprite = spriteSheetInfo:getSprite(spriteName);
if sprite == nil then
print(FUCK146U,spriteName);
end
cb(cbTarget,sprite,spriteSheetInfo.material);

else
local isNeedLoad = false;
local waitingLoadSheet = self.waitingLoadSheetDic[abName];
if waitingLoadSheet == nil then
isNeedLoad = true;
self.waitingLoadSheetDic[abName] ={};
waitingLoadSheet = self.waitingLoadSheetDic[abName];
end
local waitingSpriteList = waitingLoadSheet[spriteName];
if waitingSpriteList == nil then
waitingLoadSheet[spriteName] = {};
waitingSpriteList = waitingLoadSheet[spriteName];
end

table.insert(waitingSpriteList,{cb=cb,cbTarget=cbTarget})

if isNeedLoad then
globalManager.loaderManager:loadAsset(abName,nil,self.spriteSheetLoadComplete,self);
end
end
end

function SpriteSheetList:unloadSprite(abName,spriteName,cb,cbTarget)
local sheetInfo = self.list[abName];
if sheetInfo ~= nil then
sheetInfo:reduceCount();

local waitingLoadSheet = self.waitingLoadSheetDic[abName];
if waitingLoadSheet ~= nil then
local list = waitingLoadSheet[spriteName];
if list ~= nil then
for i = 1,#list do
if list[i].cb == cb and list[i].cbTarget == cbTarget then
table.remove(list,i);
return;
end
end
end
end

if sheetInfo:isCanDestory() then
globalManager.loaderManager:removeAsset(abName,nil,self.spriteSheetLoadComplete,self);
end
end
end

function SpriteSheetList:spriteSheetLoadComplete(abName,assetName,abContent)
print(FUCK147U,abName);
if abContent == nil then return; end
self:addSheet(abName,abContent);
print(FUCK148U,abName);
local waitingLoadSheet = self.waitingLoadSheetDic[abName];
if waitingLoadSheet ~= nil then
print(FUCK149U,abName);
local sheetInfo = self.list[abName];
local material = sheetInfo.material;
for k,v in pairs(waitingLoadSheet) do
local spriteName,list = k,v;
local len = #list;
print(FUCK150U,spriteName,len);
local sprite = sheetInfo:getSprite(spriteName);
for i=1,len do
sheetInfo:addCount();
local temp = table.remove(list,1);
temp.cb(temp.cbTarget,sprite,material);
end
end
end

self.waitingLoadSheetDic[abName] = nil;
end
BaseTemplateList = class(FUCK151U);

function BaseTemplateList:ctor()
self._templateData = nil;
self.dataLength = 0;
self.isAllParse2 = false;
self.parseComplete1 = false;
self._itemCount = 0;
self._parseItemCount1 = 0;
self._parseItemCount2 = 0;
self._list = nil;
end

function BaseTemplateList:init(data,length)
self._list = {};
self._templateData = data;
self.dataLength = length;
self._itemCount = data:readInt();
self._parseItemCount1 = 0;
if(self._itemCount == 0)then
self.parseComplete1 = true;
end
end


function BaseTemplateList:initInfo1(info)
info.id = 0;
info.dataPos = 0;
info.isParsed = false;
end


function BaseTemplateList:initInfo2(info)

end


function BaseTemplateList:parse()
local len = self:parsePerFrame1();
for i = 1,len,1 do
self:parseOne1();
self._parseItemCount1 = self._parseItemCount1 + 1;
if(self._parseItemCount1 >= self._itemCount)then
self.parseComplete1 = true;
break;
end
end
end


function BaseTemplateList:parsePerFrame1()
return self._itemCount;
end


function BaseTemplateList:parseOne1()
local info = {};
self:initInfo1(info);
self:parseKey(info);
local len = self._templateData:readUShort();
info.dataPos = self._templateData:getPosition();
if(self.isAllParse2)then
self:initInfo2(info);
self._templateData:setPosition(info.dataPos);
self:parseOne2(info);
else
self._templateData:setPosition(info.dataPos + len);
end
end


function BaseTemplateList:parseKey(info)
info.id = self._templateData:readInt();
self._list[info.id] = info;
end


function BaseTemplateList:parseOne2(info)
info.isParsed = true;
self._parseItemCount2 = self._parseItemCount2 + 1;
if(self._parseItemCount2 >= self._itemCount)then
self._templateData:reSet();
self._templateData = nil;
end
end


function BaseTemplateList:getInfo2(info)
if(info ~= nil and info.isParsed == false)then
self:initInfo2(info);
self._templateData:setPosition(info.dataPos);
self:parseOne2(info);
end
return info;
end

function BaseTemplateList:getCurReadPos()

if(self._templateData == nil)then return 99999; end
return self._templateData:getPosition();
end
LandTemplateList = class(FUCK152U,BaseTemplateList);


function LandTemplateList:ctor()
LandTemplateList.super.ctor(self);
self.isAllParse2 = false;
self.typeInfoList = {};
self.ONE_TYPE = 1;
self.TWO_TYPE = 2;
self.K_TYPE = 13;
self.BIG_JOKER_TYPE = 15;
self.SMALL_JOKER_TYPE = 14;

self.BIG_CARD_ID = 54;
self.LITTLE_CARD_ID = 53;
end

function LandTemplateList:initInfo1(info)
info.id = 0;
info.type = 0;
info.dataPos = 0;
info.isParsed = false;
end

function LandTemplateList:initInfo2(info)
info.color = 0;
info.size = 0;
end

function LandTemplateList:parseKey(info)
info.id = self._templateData:readByte();
info.type = self._templateData:readByte();
self._list[info.id] = info;
if self.typeInfoList[info.type] == nil then
self.typeInfoList[info.type] = {};
end
table.insert(self.typeInfoList[info.type],info);
end

function LandTemplateList:parseOne2(info)
info.color = self._templateData:readByte();
info.size = self._templateData:readByte();
LandTemplateList.super.parseOne2(self,info);

end

function LandTemplateList:getInfo(id)
return self:getInfo2(self._list[id]);
end

function LandTemplateList:getSizeByType(type)
local list = self.typeInfoList[type];
if #list > 0 then
local temp = self:getInfo2(list[1]);
return temp.size;
end
return 0;
end
PokerHandTemplateList = class(FUCK153U,BaseTemplateList);


function PokerHandTemplateList:ctor()
PokerHandTemplateList.super.ctor(self);
self._listByCount = {};
self.isAllParse2 = true;

self.ONE_CARD_TYPE = 1;
self.TWO_CARD_TYPE = 2;

end

function PokerHandTemplateList:initInfo1(info)
info.type = 0;
info.dataPos = 0;
info.isParsed = false;
end

function PokerHandTemplateList:initInfo2(info)
info.limitCount = 0;

info.otherCount = 0;

info.pokerHandList = nil;

info.handleTypeList = nil;

info.pressTypeList = nil;

info.otherPokerList = nil;

info.exceptPokers = nil;
info.descript = "";
end

function PokerHandTemplateList:parseKey(info)
info.type = self._templateData:readShort();
info.limitCount = self._templateData:readByte();
self._list[info.type] = info;
if self._listByCount[info.limitCount] == nil then
self._listByCount[info.limitCount] = {};
end

table.insert(self._listByCount[info.limitCount],info);
end

function PokerHandTemplateList:parseOne2(info)
function sortFunc(type1,type2)
local size1 = globalConst.landTemplateList:getSizeByType(type1);
local size2 = globalConst.landTemplateList:getSizeByType(type2);
return size1 < size2;
end

info.pokerHandList = strSplitToInts(self._templateData:readString());
info.handleTypeList = strSplitToInt(self._templateData:readString(),FUCK154U);
info.pressTypeList = strSplitToInt(self._templateData:readString(),FUCK155U);

info.otherPokerList = strSplitToInt(self._templateData:readString(),FUCK156U);
info.otherCount = self._templateData:readShort();

info.exceptPokers = strSplitToInts(self._templateData:readString());

info.descript = self._templateData:readString();

PokerHandTemplateList.super.parseOne2(self,info);
end

function PokerHandTemplateList:getInfo(type)
return self:getInfo2(self._list[type]);
end

function PokerHandTemplateList:getListByCount(count)
return self._listByCount[count];
end


function PokerHandTemplateList:getHandTpye(typelist)
function sortFunc(type1,type2)
local size1 = globalConst.landTemplateList:getSizeByType(type1);
local size2 = globalConst.landTemplateList:getSizeByType(type2);
return size1 < size2;
end
table.sort(typelist,sortFunc);
local count = #typelist;
local list = self:getListByCount(count);

if list == nil then return -1; end

for i=1,#list do
local temp = list[i];
local pokerHandList = temp.pokerHandList;
if temp.otherCount == 0 then
for j=1,#pokerHandList do
local cardTypes = pokerHandList[j];
local isSame = true;
for k=1,count do
if typelist[k] ~= cardTypes[k] then
isSame = false
break;
end
end
if isSame then
return temp.type,cardTypes;
end
end
else
for j=1,#pokerHandList do
local cardTypes = pokerHandList[j];

local otherCardTypes = self:containArray(typelist,cardTypes);

local isSame = true;

if otherCardTypes ~= nil then

if #temp.otherPokerList > 0 then
local handype = temp.otherPokerList[1];
local handypeCount = temp.otherPokerList[2];

local ret = arraySplitByCount(otherCardTypes,handypeCount);

for k=1,#ret do







local curHandype = self:getHandTpye(ret[k]);
if curHandype ~= handype then
isSame = false;
break;
end
end
end
if isSame then
local exceptPokers = temp.exceptPokers;

if #exceptPokers > 0 then
local exceptCardTypes = exceptPokers[j];
local otherExceptCardTypes = self:containArray(otherCardTypes,exceptCardTypes);

if otherExceptCardTypes ~= nil then
isSame = false;
end
end
end

if isSame then
return temp.type,cardTypes;
end
end
end

end
end
return -1;
end


function PokerHandTemplateList:containArray(array1,array2)
local array = clone(array1);
for i=1,#array2 do
local index = arrayIndexOf(array,array2[i]);
if index == -1 then
return nil;
else
table.remove(array,index);
end
end
return array;
end

function PokerHandTemplateList:isSameHandtype(typelist1,typelist2)
local handType1 = self:getHandTpye(typelist1);
local handType2 = self:getHandTpye(typelist2);
return handType1 == handType2;
end


function PokerHandTemplateList:compareCards(typelist1,typelist2)
local handType1 = self:getHandTpye(typelist1);
local handType2 = self:getHandTpye(typelist2);
if handType1 == handType2 then

for i=1,#typelist1 do
local size1 = globalConst.landTemplateList:getSizeByType(typelist1[i]);
local size2 = globalConst.landTemplateList:getSizeByType(typelist2[i]);
if size1 > size2 then
return 1;
elseif size1 < size2 then
return 2;
end
end
else
local temp1 = self:getInfo(handType1);
local handleTypeList1 = temp1.handleTypeList;

if #handleTypeList1 > 1 then
local index = arrayIndexOf(handleTypeList1,handType2);

if index ~= -1 then
return 1;
end
end

local temp2 = self:getInfo(handType2);
local handleTypeList2 = temp2.handleTypeList;

if #handleTypeList2 > 1 then
local index = arrayIndexOf(handleTypeList2,handType1);

if index ~= -1 then
return 2;
end
end

return 0;
end
end
LoaderManager = class(FUCK157U);

function LoaderManager:ctor()
self._abLoaders = {};

end

function LoaderManager:loadAsset(abName,assetName,callback,target)
print(FUCK158U,abName,assetName);
local abLoader = self._abLoaders[abName];
if self._abLoaders[abName] == nil then
abLoader = AssetLoader:new(abName);
self._abLoaders[abName] = abLoader;
end
abLoader:addCB(callback,target,assetName);
abLoader:doLoad();
end

function LoaderManager:removeAsset(abName,assetName,callback,target)
local abLoader = self._abLoaders[abName];
if abLoader ~= nil then
abLoader:removeCB(callback,target);
if abLoader:isCanRemove() then
self._abLoaders[abName]:dispose();
self._abLoaders[abName] = nil;
end
end
end

function LoaderManager:loadText(name,callback,target)
local abLoader = AssetLoader:new(name);
abLoader:setLoadType(1);
abLoader:addCB(callback,target);
abLoader:doLoad();
end

function LoaderManager:loadBytes(name, callback, target)
local abLoader = AssetLoader:new(name);
abLoader:setLoadType(2);
abLoader:addCB(callback, target);
abLoader:doLoad();
end


function LoaderManager:loadTexture(name, callback, target)
local abLoader = AssetLoader:new(name);
abLoader:setLoadType(3);
abLoader:addCB(callback, target);
abLoader:doLoad();
end

function LoaderManager:clearAll()
for k,v in pairs(self._abLoaders) do
v:dispose();
self._abLoaders[k] = nil;
end
end
PathManager = class(FUCK159U);

function PathManager:ctor()

end

function PathManager:getCommonUIPath()
return FUCK160U;
end

function PathManager:getCommonItemPrefabPath()
return FUCK161U;
end


PoolManager = class(FUCK162U);

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
self.types[FUCK163U] = {Node,self.uiNodeList,10};
self.types[FUCK164U] = {Label,self.uiLabelList,10};
self.types[FUCK165U] = {Image,self.uiImageList,10};
self.types[FUCK166U] = {Button,self.uiImageList,10};
self.types[FUCK167U] = {RichLabel,self.uiRichLabelList,10};

self.types[FUCK168U] = {QuoteData,self.quoteDataList,10};

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

item.__isInPoolList = false;

item.__isForPoolList = true;
return item,false;
else
item = typeClass:new();
item.__isInPoolList = false;

item.__isForPoolList = true;
return item,true;
end
end

item = typeClass:new();

item.__isInPoolList = false;

item.__isForPoolList = false;
return item,true;
end

function PoolManager:putItem(item,itemType)

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

item.__isInPoolList = true;
end
end
end

function PoolManager:createQuoteData(usePool)
return self:createItem(usePool,FUCK169U);
end

function PoolManager:createNode(usePool)
return self:createItem(usePool,FUCK170U);
end

function PoolManager:createLabel(usePool)
return self:createItem(usePool,FUCK171U);
end

function PoolManager:createImage(usePool)
return self:createItem(usePool,FUCK172U);
end

function PoolManager:createButton(usePool)
return self:createItem(usePool,FUCK173U);
end

function PoolManager:createRichLabel(usePool)
return self:createItem(usePool,FUCK174U);
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
self:putItem(item,FUCK175U);
end

function PoolManager:putNode(item)
self:putItem(item,FUCK176U);
end

function PoolManager:putLabel(item)
self:putItem(item,FUCK177U);
end

function PoolManager:putImage(item)
self:putItem(item,FUCK178U);
end

function PoolManager:putButton(item)
self:putItem(item,FUCK179U);
end

function PoolManager:putRichLabel(item)
self:putItem(item,FUCK180U);
end

TriggerManager = class(FUCK181U);

function TriggerManager:ctor()
self._handlerList = {};







end


function TriggerManager:doHandler(info,param)
if info == nil then return;end
local trigger = self._handlerList[info.type];
if trigger ~= nil then
trigger:handler(info,param);
end
end
CardController = class(FUCK182U);

function CardController:ctor()

self._curHandCards = nil;

self._cardItemList = nil;

self._selfPosXList = nil;
self._curAnimIdx = nil;
self._curCardInfoList = nil;
self._selfCardItemList = nil;

self._tickCount = 0;

self._startPosX = nil;
self._startPosY = nil;
self._isMoving = false;
self._isDragingCardFlags = nil;

self:initCardContainers();
self:initEvent();

end

function CardController:initCardContainers()
local types = {1,3,2};
self._originPosList = {};
self._originPosList[1] = {x = globalManager.uiManager.canvas_width/2+30, y = -10-globalManager.uiManager.canvas_height/2};
self._originPosList[2] = {x = 1000, y = -275};
self._originPosList[3] = {x = 120, y = -275};
self._outCardItemContainerList = {};
for i=1,3 do
local outCardItemContainer = CardItemContainer:new(types[i]);
outCardItemContainer:setMargin(-60);
if i == globalData.cardInfo.mySeat then
outCardItemContainer:setScale(0.8,0.8,0.8);
else
outCardItemContainer:setScale(0.6,0.6,0.6);
end
outCardItemContainer:setParent(globalManager.uiManager.mainTransform);
outCardItemContainer:setOriginPos(self._originPosList[i].x,self._originPosList[i].y);
table.insert(self._outCardItemContainerList,outCardItemContainer);
end

self._leftCardItemContainer = CardItemContainer:new(2);
self._leftCardItemContainer:setMargin(-60);
self._leftCardItemContainer:setScale(0.6,0.6,0.6);
self._leftCardItemContainer:setParent(globalManager.uiManager.mainTransform);
self._leftCardItemContainer:setOriginPos(10,-globalManager.uiManager.canvas_height/2+180);

self._rightCardItemContainer = CardItemContainer:new(3);
self._rightCardItemContainer:setMargin(-60);
self._rightCardItemContainer:setScale(0.6,0.6,0.6);
self._rightCardItemContainer:setParent(globalManager.uiManager.mainTransform);
self._rightCardItemContainer:setOriginPos(globalManager.uiManager.canvas_width - 10,-globalManager.uiManager.canvas_height/2+180);


self._selfCardItemContainer = CardItemContainer:new();
self._selfCardItemContainer:setMargin(-60);
self._selfCardItemContainer:setParent(globalManager.uiManager.mainTransform);
self._selfCardItemContainer:setOriginPos(globalManager.uiManager.canvas_width/2,-globalManager.uiManager.canvas_height+90);
self._cardItemContaierList = {self._selfCardItemContainer,self._rightCardItemContainer,self._leftCardItemContainer};

end


function CardController:initEvent()
globalData.cardServerInfo:addEventListener(globalConst.eventType.card_out,self.outCardsHandler,self);
globalManager.gameEventDispatcher:addEventListener(globalConst.eventType.deal_cards,self.start,self);
end

function CardController:removeEvent()
globalData.cardServerInfo:removeEventListener(globalConst.eventType.card_out,self.outCardsHandler,self);
globalManager.gameEventDispatcher:removeEventListener(globalConst.eventType.deal_cards,self.start,self);
end

function CardController:start()
self:clearCards();

globalData.cardServerInfo:startGame();

self._curAnimIdx = 1;
self._selfCardItemList = {};

self._curCardInfoList = {};
for i=1,3 do
local curCards = globalData.cardServerInfo:getCurCardInfoList(i);
table.insert(self._curCardInfoList,curCards);
if i ~= globalData.cardInfo.mySeat then
for j=1,#curCards do
local cardItem = CardItem:new();
cardItem:setInfo(curCards[j]);
self._cardItemContaierList[i]:pushBackItem(cardItem);
end
end
end

globalManager.tickManager:addTick(self.startAnimTick,self);
end

function CardController:startAnimTick()
self._tickCount = self._tickCount + 1;

if self._tickCount < 4 then return; end
self._tickCount = 0;
local curCards = self._curCardInfoList[globalData.cardInfo.mySeat];
local cardItem = CardItem:new();
cardItem:setInfo(curCards[self._curAnimIdx]);
cardItem:addTouchCallBack(self.cardItemClickHandler,self);
table.insert(self._selfCardItemList,cardItem);
self._selfCardItemContainer:pushBackItem(cardItem);

self._curAnimIdx = self._curAnimIdx + 1;
if self._curAnimIdx > #curCards then
globalManager.tickManager:removeTick(self.startAnimTick,self);
end
end

function CardController:checkDragCard(x,y)
for i=1,#self._selfCardItemList do
if self._isDragingCardFlags[i] ~= true then
if self._selfCardItemList[i]:isInside(x,y) then
self._isDragingCardFlags[i] = true;
self._selfCardItemList[i]:setIsDraging(true);
end
end
end
end

function CardController:dragBeginHandler(sender,x,y)
self._startPosX = x;
self._startPosY = y;
self._isMoving = false;
self._isDragingCardFlags = {};
end

function CardController:dragingHandler(sender,x,y)
if math.abs(self._startPosX - x) > 3 and math.abs(self._startPosY - y) > 3 then
self._isMoving = true;
end
if self._isMoving then
self:checkDragCard(x,y);
end

end

function CardController:dragEndHandler(sender,x,y)
if self._isMoving then
for i=1,#self._selfCardItemList do
local item = self._selfCardItemList[i];
if self._isDragingCardFlags[i] == true then
local cardItemInfo = item:getInfo();
item:setSelect(true);
globalData.cardInfo:setSelectCards(cardItemInfo,true);
end
item:setIsDraging(false);
end
else
for i=1,#self._selfCardItemList do
local item = self._selfCardItemList[i];
if item:isInside(x,y) then
local isSelect = not item:getIsSelect();
item:setSelect(isSelect);
local cardItemInfo = item:getInfo();
globalData.cardInfo:setSelectCards(cardItemInfo,isSelect);
break;
end
item:setIsDraging(false)
end
end

end

function CardController:cardItemClickHandler(sender,x,y)
local isSelect = not sender:getIsSelect();
local cardItemInfo = sender:getInfo();
globalData.cardInfo:setSelectCards(cardItemInfo,isSelect);
end

function CardController:outCardsHandler(seat)
self._outCardItemContainerList[seat]:removeAllItems();
local outcards = globalData.cardServerInfo:getCurOutCards(seat);
if outcards == nil then return; end


for i=1,#outcards do
local cardItem = CardItem:new();
cardItem:setInfo(outcards[i]);
self._outCardItemContainerList[seat]:pushBackItem(cardItem);

local index = arrayIndexOf(self._curCardInfoList[seat],outcards[i])
if index ~= -1 then
table.remove(self._curCardInfoList[seat],index);

self._cardItemContaierList[seat]:removeItem(index);
if seat == globalData.cardInfo.mySeat then
table.remove(self._selfCardItemList,index);
end
end
end
end


function CardController:clearCards()
self._curCardInfoList = nil;
self._selfCardItemList = nil;
for i=1,#self._cardItemContaierList do
self._cardItemContaierList[i]:removeAllItems();
end

globalManager.tickManager:removeTick(self.startAnimTick,self);
end

function CardController:dispose()
self:clearCards();
if self._outCardItemContainerList ~= nil then
for i=1,#self._outCardItemContainerList do
self._outCardItemContainerList[i]:dispose();
self._outCardItemContainerList[i] = nil;
end
self._outCardItemContainerList = nil;
end
self._selfCardItemContainer = nil;
if self._cardItemContaierList ~= nil then
for i=1,#self._cardItemContaierList do
self._cardItemContaierList[i]:dispose();
self._cardItemContaierList[i] = nil;
end
self._cardItemContaierList = nil;
end
self:removeEvent();
end
CardItem = class(FUCK183U,HotAreaNode)

function CardItem:ctor()
self._cardBg = nil;

self._cardNum = nil;
self._colorImg = nil;
CardItem.super.ctor(self);

self._selfPosY = nil;
self._isSelect = false;

self._cardItemInfo = nil;
self:setByPrefab(globalData.commonItemPrefabs[FUCK184U]);
end

function CardItem:setByPrefab(prefab)
CardItem.super.setByPrefab(self,prefab);
self:initUI();
self:initEvent();
end

function CardItem:initUI()
self._cardBg = self:getChildByName(FUCK185U,FUCK186U);
self._cardNum = self:getChildByName(FUCK187U,FUCK188U);

self._colorImg = self:getChildByName(FUCK189U,FUCK190U);

end

function CardItem:initEvent()
globalData.cardInfo:addEventListener(globalConst.eventType.select_card_handle,self.selectCardHandler,self);
end

function CardItem:removeEvent()
globalData.cardInfo:removeEventListener(globalConst.eventType.select_card_handle,self.selectCardHandler,self);
end

function CardItem:setInfo(cardItemInfo)
self._cardItemInfo = cardItemInfo;
self:updateView();
end

function CardItem:updateView()
if self._cardItemInfo.id == globalConst.landTemplateList.LITTLE_CARD_ID then
self._cardNum:hide();
self._colorImg:hide();
self._cardBg:loadUISprite(FUCK191U);

elseif self._cardItemInfo.id == globalConst.landTemplateList.BIG_CARD_ID then
self._cardNum:hide();
self._colorImg:hide();
self._cardBg:loadUISprite(FUCK192U);
else
local spriteName = FUCK193U..self._cardItemInfo.type;
if self._cardItemInfo.color % 2 == 1 then
spriteName = spriteName..FUCK194U;
end
self._cardNum:loadUISprite(spriteName);

self._colorImg:loadUISprite(FUCK195U..self._cardItemInfo.color);
end
end

function CardItem:setIsDraging(isDraging)
if isDraging then
self._cardBg:setColor(globalConst.colorConst.cardSelectColor);
self._cardNum:setColor(globalConst.colorConst.cardSelectColor);
self._colorImg:setColor(globalConst.colorConst.cardSelectColor);
else
self._cardBg:setColor(globalConst.colorConst.white);
self._cardNum:setColor(globalConst.colorConst.white);
self._colorImg:setColor(globalConst.colorConst.white);
end
end

function CardItem:selectCardHandler(cardItemInfo)
if self._cardItemInfo ~= cardItemInfo then return; end
self:setSelect(self._cardItemInfo.isSelect);
end

function CardItem:setSelect(isSelect)

local posY = self:getPosition().y;
if self._selfPosY == nil then
self._selfPosY = posY;
end
self._isSelect = isSelect;
if self._isSelect then
self:setPosition(nil,self._selfPosY+20);
else
self:setPosition(nil,self._selfPosY);
end
end

function CardItem:getInfo()
return self._cardItemInfo;
end

function CardItem:isInside(x,y)
local screenPos = globalManager.poolManager:createVector2(x,y);
local localPos = screen2LocalPos(screenPos,self.transform);
local size = self:getSize();
return localPos.x >= 0 and localPos.x <= size.x and localPos.y <= 0 and localPos.y >= -size.y;
end

function CardItem:getIsSelect()
return self._isSelect;
end

function CardItem:dispose()
self._cardBg = nil;
self._cardNum = nil;
self._colorImg = nil;
self._cardItemInfo = nil;
self:removeEvent();
CardItem.super.dispose(self);
end
CardItemContainer = class(FUCK196U,HotAreaNode)


function CardItemContainer:ctor(type)
CardItemContainer.super.ctor(self);

self._type = type or 1;
self._margin = 0;
self._itemList = {};
self._originX = nil;
self._originY = nil;
self:setObject(newObject(FUCK197U));
self:setPivot(globalManager.kCreator.pivotPoint1);
end

function CardItemContainer:setMargin(margin)
self._margin = margin;
end

function CardItemContainer:refresh()
local totalW = 0;
local totalH = 0;
local len = #self._itemList;

for i=1,len do
local item = self._itemList[i];
local size = item:getSize();
if i == 1 then
totalW = totalW + size.x;
else
totalW = totalW + self._margin + size.x;
end
if totalH < size.y then totalH = size.y; end
item:setPosition((size.x+self._margin)*(i-1),0);
end
self:setSize(totalW,totalH);

if self._type == 1 then
self:setPosition(self._originX-totalW/2,self._originY+totalH/2);
elseif self._type == 2 then
self:setPosition(self._originX,self._originY);
elseif self._type == 3 then
self:setPosition(self._originX - totalW*self._scale.x,self._originY);
end
end

function CardItemContainer:pushBackItem(item)
self:addNode(item);
table.insert(self._itemList,item);
self:refresh();
end

function CardItemContainer:removeItem(index,isDispose)
if isDispose == false then
self._itemList[index]:setParent(nil);
else
self._itemList[index]:dispose();
end
table.remove(self._itemList,index);
self:refresh();
end

function CardItemContainer:removeAllItems()
for i=1,#self._itemList do
self._itemList[i]:dispose();
self._itemList[i] = nil;
end
self._itemList = {};
end

function CardItemContainer:getItem(index)
return self._itemList[index];
end

function CardItemContainer:setOriginPos(x,y,z)
self._originX = x;
self._originY = y;
self:setPosition(x,y,z);
end


function CardItemContainer:dispose()
for i=1,#self._itemList do
self._itemList[i]:dispose();
self._itemList[i] = nil;
end
self._itemList = nil;
CardItemContainer.dispose.ctor(self);
end

ClockItem = class(FUCK198U,HotAreaNode)

function ClockItem:ctor()

self._timeLabel = nil;

self:setByPrefab(globalData.commonItemPrefabs[FUCK199U]);

self._restSec = 0;
self._lastTime = 0;
end

function ClockItem:setByPrefab(prefab)
ClockItem.super.setByPrefab(self,prefab);
self:initUI();
end

function ClockItem:initUI()
self._timeLabel = self:getChildByName(FUCK200U,FUCK201U);
print(FUCK202U,self._timeLabel:getPosition().y);
self._timeLabel:setAlign(UnityEngine.TextAnchor.MiddleCenter);

end

function ClockItem:start(restSec)
self:show();
self._restSec = restSec;
globalManager.tickManager:addTick(self.timeTick,self);
end

function ClockItem:timeTick()
local nowTime = globalData.systemDateInfo:getSystemTimeSec();
if nowTime - self._lastTime > 1 then
self._lastTime = nowTime;
self._restSec = self._restSec - 1;
if self._restSec > 0 then
self:updateTimeLabel();
else
self:hide();
globalManager.tickManager:removeTick(self.timeTick,self);
end
end
end

function ClockItem:updateTimeLabel()
self._timeLabel:setString(self._restSec);
end

function ClockItem:dispose()
globalManager.tickManager:addTick(self.timeTick,self);
ClockItem.super.dispose(self);
end
GameScene = class(FUCK203U);

function GameScene:ctor()
self._bg = nil;
self._gameView = nil;
self._clockItem = nil;
self._cardController = nil;

self:init();
end

function GameScene:init()
self._bg = globalManager.kCreator:createImage();
self._bg:loadOutPic(FUCK204U,FUCK205U);
self._bg:setPosition(globalManager.uiManager.PANEL_WIDTH/2,-globalManager.uiManager.PANEL_HEIGHT/2);
self._bg:setParent(globalManager.uiManager.mainTransform);

self._gameView = GameView:new();








self._cardController = CardController:new();
end

function GameScene:dispose()
if self._bg ~= nil then
self._bg:dispose();
self._bg = nil;
end

if self._gameView ~= nil then
self._gameView:dispose();
self._gameView = nil;
end

if self._cardController ~= nil then
self._cardController:dispose();
self._cardController = nil;
end

globalManager.tickManager:removeTick(self.startAnimTick,self);
end
GameView = class(FUCK206U,Node)

function GameView:ctor()
self._tipBtn = nil;
self._outBtn = nil;
self._exitBtn = nil;
self._passBtn = nil;
self._outLayer = nil;
self._prepareLayer = nil;
self._callLanderLayer = nil;
self:loadNodeAb(FUCK207U,FUCK208U);
end

function GameView:setByPrefab(prefab)
GameView.super.setByPrefab(self,prefab);
self:initUI();
end

function GameView:initUI()
self:setParent(globalManager.uiManager.mainTransform);
self._exitBtn = self:getChildByName(FUCK209U,FUCK210U);
self._outLayer = self:getChildByName(FUCK211U,FUCK212U);
self._tipBtn = self:getChildByName(FUCK213U,FUCK214U);
self._outBtn = self:getChildByName(FUCK215U,FUCK216U);
self._prepareLayer = self:getChildByName(FUCK217U,FUCK218U);
self._passBtn = self:getChildByName(FUCK219U,FUCK220U);
self._callLanderLayer = self:getChildByName(FUCK221U,FUCK222U);


self._prepareLayer:hide();
self._callLanderLayer:hide();

self:initEvent();
end

function GameView:initEvent()
self._tipBtn:addTouchCallBack(self.btnClickHandler,self);
self._outBtn:addTouchCallBack(self.btnClickHandler,self);
self._exitBtn:addTouchCallBack(self.btnClickHandler,self);
self._passBtn:addTouchCallBack(self.btnClickHandler,self);
end

function GameView:btnClickHandler(sender)
if sender == self._outBtn then
if globalData.cardInfo:checkSelectCards() then
globalData.cardServerInfo:setCurOutCards(globalData.cardInfo.mySeat,globalData.cardInfo.selectCards);
globalData.cardInfo.selectCards = nil;
end
elseif sender == self._tipBtn then
globalData.cardServerInfo.cardPlayerInfoList[1]:checkHandCards();

elseif sender == self._passBtn then

elseif sender == self._exitBtn then
globalData.cardInfo:clearCards();
globalManager.gameEventDispatcher:dispatchEvent(globalConst.eventType.deal_cards);
end
end

function GameView:dispose()
self._exitBtn = nil;
GameView.super.dispose(self);
end
PlayerHeadItem = class(FUCK223U,HotAreaNode)

function PlayerHeadItem:ctor()

PlayerHeadItem.super.ctor(self);

self:setByPrefab(globalData.commonItemPrefabs[FUCK224U]);
end

function PlayerHeadItem:setByPrefab(prefab)
PlayerHeadItem.super.setByPrefab(self,prefab);
self:initUI();
end

function PlayerHeadItem:initUI()


end

function PlayerHeadItem:setInfo()


self:updateView();
end

function PlayerHeadItem:updateView()

end


function PlayerHeadItem:dispose()

PlayerHeadItem.super.dispose(self);
end
PlayerHeadItemController = class(FUCK225U);

function PlayerHeadItemController:ctor()
self._posList = {};
self._headWidth = 94;
self._headHeight = 98;
self._posList[1] = {x = 5,y = -globalManager.uiManager.canvas_height+self._headHeight+5};
self._posList[2] = {x = 5,y = -globalManager.uiManager.canvas_height/2+self._headHeight/2};
self._posList[3] = {x = globalManager.uiManager.canvas_width - self._headWidth - 5,y = -globalManager.uiManager.canvas_height/2+self._headHeight/2};

self._headItemList = nil;
end

function PlayerHeadItemController:init()
self._headItemList = {};
for i=1,#self._posList do
local headItem = PlayerHeadItem:new();
headItem:setPosition(self._posList[i].x,self._posList[i].y);
headItem:setParent(globalManager.uiManager.mainTransform);
table.insert(self._headItemList,headItem);
end
end

function PlayerHeadItemController:dispose()
if self._headItemList ~= nil then
for i=1,#self._headItemList do
self._headItemList[i]:dispose();
self._headItemList[i] = nil;
end
self._headItemList = nil;
end
end
RichLabel = class(FUCK226U,Label);

function RichLabel:ctor()
self._faceList = {};
self._newObjList = {};
self._lastLinkClickTime = 0;
RichLabel.super.ctor(self);
end


function RichLabel:createComponent()
self.component = self.go:GetComponent(typeof(LinkImageText));
if self.component == nil then
self.component = self.go:AddComponent(typeof(LinkImageText));
self.component.font = globalData.defaultFont;
self.component.raycastTarget = false;
end
self.component.color.a = 1;
self:setTouchEnabled(true);
end

function RichLabel:setTouchEnabled(v)
RichLabel.super.setTouchEnabled(self,v);
if self.component ~= nil then
self.component.onLinkClick:AddListener(function(index)self:onLinkClick(index);end)
end
end


function RichLabel:onLinkClick(index)
local nowTime = os.time();

if nowTime - self._lastLinkClickTime < 1 then
return;
end
self._lastLinkClickTime = nowTime;


local info = self._linkInfoList[index];
print(FUCK227U,index,info);
globalManager.triggerManager:doHandler(info);
end

function RichLabel:btnClickHandler(sender)
local index = sender.index;
local info = self._btnClickInfoList[index];
globalManager.triggerManager:doHandler(info);
end

function RichLabel:setString(str)
self:clearData();


str = string.gsub(str,globalConst.handlePattern,function(s)return self:handlePattern(s);end)
RichLabel.super.setString(self,str);
if #self._elementDatas > 0 then
globalManager.tickManager:addTick(self.tick,self);
end
end

function RichLabel:tick()
if  self.component.m_positionList.Count ~= #self._elementDatas then

return;
end

self._positonList = self.component.m_positionList;
globalManager.tickManager:removeTick(self.tick,self);

self:createElementList();
end


function RichLabel:createElementList()
for i = 1,#self._elementDatas do
local element = self._elementDatas[i];
local pos = self._positonList[i-1];
self:createElement(element[1],element[2],element[3],element[4],element[5],element[6],pos);
end


end


function RichLabel:sortImgs()
local allCount = self.transform.childCount;
local tmp = nil;
for i=0,allCount-1 do
tmp = self.transform:GetChild(i);
if tmp.name == FUCK228U then
tmp:SetAsFirstSibling();
end
end
end

function RichLabel:createElement(groupType,name,width,height,offsetX,offsetY,pos)
local obj = nil;









if obj ~= nil then
obj:setPosition(pos.x + offsetX,pos.y + self.component.fontSize + offsetY,true,true);
self:addNode(obj);
end
end

function RichLabel:handlePattern(str)
local content = string.sub(str,3,#str - 2);
local triggerInfo = TriggerInfo:new();
triggerInfo:initWithString(content);
if triggerInfo == nil then return;end
local result = "";
local key = triggerInfo.descript;
if triggerInfo.group == globalConst.triggerType.imageGroup then
local imgWidth,imgHeight = triggerInfo.params[1],triggerInfo.params[2];

result = FUCK229U..key..FUCK230U..imgHeight..FUCK231U..(imgWidth/imgHeight)..FUCK232U;
table.insert(self._elementDatas,{triggerInfo.group,key,imgWidth,imgHeight,-3,-12});

elseif triggerInfo.group == globalConst.triggerType.clickTxtGroup then
table.insert(self._linkInfoList,triggerInfo);
result = FUCK233U..triggerInfo.descript..FUCK234U;

elseif triggerInfo.group == globalConst.triggerType.underlineGroup then
table.insert(self._linkInfoList,triggerInfo);

result = FUCK235U..triggerInfo.descript..FUCK236U;

end
return result;
end

function RichLabel:getTextSize()
if self.component ~= nil then
return self.component.preferredWidth,self.component.preferredHeight;
end
return nil;
end

function RichLabel:doClear()
self:setString("");
globalManager.tickManager:removeTick(self.tick,self);
self:clearData();
self:setRich(true);
RichLabel.super.doClear(self);
end

function RichLabel:clearData()
for i = 1,#self._faceList do
self._faceList[i]:dispose();
end
for i = 1,#self._newObjList do
self._newObjList[i]:dispose();
self._newObjList[i] = nil;
end
self._faceList = {};
self._newObjList = {};
self._positonList = nil;
self._linkInfoList = {};
self._elementDatas = {};
self._btnClickInfoList = {};
if self.component ~= nil and self.component.m_positionList ~= nil then
self.component.m_positionList:Clear();
end
end

function RichLabel:dispose()
globalManager.poolManager:putRichLabel(self);
end
