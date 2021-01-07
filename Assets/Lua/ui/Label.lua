Label = class("Label",Node);

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

-- 行间距
function Label:setLineSpacing(value)
	self.component.lineSpacing = value;
end

--UnityEngine.FontStyle.Normal(默认)
--UnityEngine.FontStyle.Bold(加粗)
--UnityEngine.FontStyle.Italiclic(倾斜)
--UnityEngine.FontStyle.BoldAndItalic(加粗倾斜)
function Label:setFontStyle(style)
	self.component.fontStyle = style;
end

-- UnityEngine.TextAnchor.UpperLeft;
-- UnityEngine.TextAnchor.UpperCenter;
-- UnityEngine.TextAnchor.UpperRight;
-- UnityEngine.TextAnchor.MiddleLeft;
-- UnityEngine.TextAnchor.MiddleCenter;
-- UnityEngine.TextAnchor.MiddleRight;
-- UnityEngine.TextAnchor.LowerLeft;
-- UnityEngine.TextAnchor.LowerCenter;
-- UnityEngine.TextAnchor.LowerRight;
function Label:setAlign(align)
	self.component.alignment = align;
end

--UnityEngine.HorizontalWrapMode.Wrap(换行)
--UnityEngine.HorizontalWrapMode.Overflow(强行超出)
function Label:setHOverflow(overflow)
	self.component.horizontalOverflow = overflow;
end

--UnityEngine.VerticalWrapMode.Truncate(不显示)
--UnityEngine.VerticalWrapMode.Overflow强行超出)
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