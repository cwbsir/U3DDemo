InputLabel = class("InputLabel",Label);

function InputLabel:ctor()
	self._inputComponent = nil;
	self._changeCallback = nil;
	self._changeTarget = nil;
	self._endCallback = nil;
	self._endTarget = nil;
	self._activeCallback = nil;
	self._activeTarget = nil;
	--是否正在输入
	self._isInputing = false;
	-- 占位符 文本
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

--激活inputLabel并且唤醒输入框
function InputLabel:active()
	if self._inputComponent ~= nil then
		self._inputComponent:ActivateInputField();
	end
end

--关闭输入框
function InputLabel:deactive()
	if self._inputComponent ~= nil then
		self._inputComponent:DeactivateInputField();
	end
end


--是否已经唤醒
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
	--编辑结束，置成false
	self._isInputing = false;
	if self._endCallback ~= nil then
		self._endCallback(self._endTarget,value,self);
	end
end

--点击回调
function InputLabel:inputClickHandler()
	if self._isInputing == true then
		return;
	end
	--编辑开始，置成active（如果不能输入的情况下，点击之后不会激活label）
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

--设置是否可以输入
function InputLabel:setInteractable(value)
	self._inputComponent.interactable = value;
end

--UnityEngine.UI.InputField.LineType.SingleLine(单行)
--UnityEngine.UI.InputField.LineType.MultiLineSubmit(多行但是回车执行提交)
--UnityEngine.UI.InputField.LineType.MultiLineNewlineeNewline(多行但是回车执行换行)
function InputLabel:setLineType(type)
	self._inputComponent.lineType = type;
end
--可输入最大字符长度（0为不限制，中文也为1个字符）
function InputLabel:setMaxLength(limit)
	self._inputComponent.characterLimit = limit;
end
--Default(常规默认) 0
--NumberPad(数字键盘) 4
function InputLabel:setKeyboardType(type)
	self._inputComponent.keyboardType = type;
end
--UnityEngine.UI.InputField.ContentType.Standard(常规默认)
--UnityEngine.UI.InputField.ContentType.IntegerNumber(整数)
--UnityEngine.UI.InputField.ContentType.Alphanumeric(大小写字母和数字)
--UnityEngine.UI.InputField.ContentType.Password(密码)
--UnityEngine.UI.InputField.ContentType.Pin(纯数字密码)
function InputLabel:setContentType(type)
	self._inputComponent.contentType = type;
end

-- 文本改变 回调 callback(string) 返回的是改变后的文本内容
function InputLabel:setValueChangedCB(callback,target)
	self._changeCallback = callback;
	self._changeTarget = target;
end

-- 文本输入结束 回调 callback(string) 返回的是文本内容
function InputLabel:setEndEditCB(callback,target)
	self._endCallback = callback;
	self._endTarget = target;
end

-- 文本输入开始 回调 callback(self) 返回的是当前这个控件 
function InputLabel:setActiveCB(callback,target)
	self._activeCallback = callback;
	self._activeTarget = target;
end


-- 设置占位符文本
function InputLabel:setDefauleStr(value,color)
	color = color or globalConst.colorConst.gray;
	if self._defaultStrLabel == nil then
		self._defaultStrLabel = globalManager.kCreator:createLabel("placeHolder");
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