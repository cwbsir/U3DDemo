RichLabel = class("RichLabel",Label);

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

-- 超链接点击触发
function RichLabel:onLinkClick(index)
	local nowTime = os.time();
	--防止一次点击多次触发
	if nowTime - self._lastLinkClickTime < 1 then
		return;
	end
	self._lastLinkClickTime = nowTime;


	local info = self._linkInfoList[index];
	print("超链接调用了 == ",index,info);
	globalManager.triggerManager:doHandler(info);
end

function RichLabel:btnClickHandler(sender)
	local index = sender.index;
	local info = self._btnClickInfoList[index];
	globalManager.triggerManager:doHandler(info);
end

function RichLabel:setString(str)
	self:clearData();
	-- 正则匹配 &##&内容并替换  例如：你是&#6$602$0$0$81$0$0$0#&哈&#6$602$0$0$91$0$0$0#&吗?

	str = string.gsub(str,globalConst.handlePattern,function(s)return self:handlePattern(s);end)
	RichLabel.super.setString(self,str);
	if #self._elementDatas > 0 then
		globalManager.tickManager:addTick(self.tick,self);
	end
end

function RichLabel:tick()
	if  self.component.m_positionList.Count ~= #self._elementDatas then
		-- print("!!!!!!!!!!!!报错了，占位符小于图片数，请先打开enable，再设string!!!!");
		return;
	end
	-- 占位符位置
	self._positonList = self.component.m_positionList;
	globalManager.tickManager:removeTick(self.tick,self);
	-- print("占位符长度 == ",self._positonList.Count,#self._elementDatas,self:getString());
	self:createElementList();
end

-- 创建表情，图标元素
function RichLabel:createElementList()
	for i = 1,#self._elementDatas do
		local element = self._elementDatas[i];
		local pos = self._positonList[i-1];
		self:createElement(element[1],element[2],element[3],element[4],element[5],element[6],pos);
	end
	-- 很关键！！！极大减少dc数
	-- self:sortImgs();
end

-- 把图片层次调低，方便表情批处理，减少dc
function RichLabel:sortImgs()
	local allCount = self.transform.childCount;
	local tmp = nil;
	for i=0,allCount-1 do
	 	tmp = self.transform:GetChild(i);
	 	if tmp.name == "face" then
	 		tmp:SetAsFirstSibling();
	 	end
	end 
end

function RichLabel:createElement(groupType,name,width,height,offsetX,offsetY,pos)
	local obj = nil;
	-- if groupType == globalConst.triggerType.channelImageGroup then      --货币图片
	-- 	obj = globalManager.kCreator:createImage(name,true);
	-- 	obj:setPivot(globalManager.kCreator.pivotPoint1);
	-- 	obj:loadFromSpriteSheetPicSize(globalManager.pathManager:getCommonUIPath(),name)
	-- 	obj:setSize(width,height,true,true);
	-- 	table.insert(self._newObjList,obj);
	-- else
	-- 	--dosomething
	-- end
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
	local key = triggerInfo.descript;--图片，表情 key
	if triggerInfo.group == globalConst.triggerType.imageGroup then
		local imgWidth,imgHeight = triggerInfo.params[1],triggerInfo.params[2];
		--size表示文本中所占高度，size*width才是宽度
		result = "<quad name="..key.." size="..imgHeight.." width="..(imgWidth/imgHeight).."/>";
		table.insert(self._elementDatas,{triggerInfo.group,key,imgWidth,imgHeight,-3,-12});--图片大小 
	--可点击文本处理
	elseif triggerInfo.group == globalConst.triggerType.clickTxtGroup then
		table.insert(self._linkInfoList,triggerInfo);
		result = "<a href=link u=0>"..triggerInfo.descript.."</a>";
	--下划线点击文本处理
	elseif triggerInfo.group == globalConst.triggerType.underlineGroup then
		table.insert(self._linkInfoList,triggerInfo);
		--print("颜色 == ",self._color);
		result = "<a href=link u=1>"..triggerInfo.descript.."</a>";
		--result = "<color=#ffff00>"..result.."</color>";       --默认一个颜色,可根据需求设置不同颜色
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