-- 添加热区Node
HotAreaNode = class("HotAreaNode",Node)

function HotAreaNode:ctor()
	HotAreaNode.super.ctor(self);
end

-- 通过gameObj初始化
function HotAreaNode:setObject(object)
	HotAreaNode.super.setObject(self,object);
	if object ~= nil then
		self.component = object:AddComponent(typeof(UnityEngine.UI.Image));
		self.component.color = {r=255,g=255,b=255,a=0};
	end
end