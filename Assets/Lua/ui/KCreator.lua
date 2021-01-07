KCreator = class("KCreator");


function KCreator:ctor()
	self.pivotPoint0 = Vector2.New(0.5,0.5);	--center
	self.pivotPoint1 = Vector2.New(0,1);		--topLeft
	self.pivotPoint2 = Vector2.New(0.5,1);		--topCenter
	self.pivotPoint3 = Vector2.New(1,1);		--topRight
	self.pivotPoint4 = Vector2.New(0,0.5);		--centerLeft
	self.pivotPoint5 = Vector2.New(1,0.5);		--centerRight
	self.pivotPoint6 = Vector2.New(0,0);		--bottomLeft
	self.pivotPoint7 = Vector2.New(1,0);		--bottomRight
	self.pivotPoint8 = Vector2.New(0.5,0);		--bottomCenter
end



function KCreator:createNode(name,isPool)
	name = name or "Node";
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
	name = name or "Label";
	local label,isNew = globalManager.poolManager:createLabel(isPool);
	if isNew then
		local object = UnityEngine.GameObject.Instantiate(globalData.uiPrefabs["Text"]);
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
	name = name or "Image";
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
	name = name or "Button";
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
	name = name or "RichLabel";
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

--创建输入文本
function KCreator:createInputLabel(name)
	name = name or "InputLabel";
	local object = UnityEngine.GameObject.Instantiate(globalData.uiPrefabs["InputField"]);
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

--创建ListContainer  parentTrans父类transform  contaienr容器 mainNode根节点
function KCreator:createListView(name)
	local object = UnityEngine.GameObject.Instantiate(globalData.uiPrefabs["ScrollView"]);
	local listView = ListView:new();
	listView:setObject(object);
	return listView;
end

--创建ListContainer  parentTrans父类transform  contaienr容器 mainNode根节点
function KCreator:createScrollView(name)
	local object = UnityEngine.GameObject.Instantiate(globalData.uiPrefabs["ScrollView"]);
	local scrollView = ScrollView:new();
	scrollView:setObject(object);
	return scrollView;
end