ShaderType = class("ShaderType");

function ShaderType:ctor()
	self.shaders = {};
end

function ShaderType:init(abContent)
	local s = abContent:LoadAllAssets(typeof(UnityEngine.Shader));
	local len = s.Length - 1;
	local tmps = nil;
	local tmpName = nil;
	for i = 0,len,1 do
		local tmps = string.split(s[i].name,"/");
		if #tmps > 0 then
			tmpName = tmps[#tmps];
			self.shaders[tmpName] = s[i];
			-- print("shader名称 == ",i,s[i].name,tmpName);
		end
	end

	-- PSD2UGUI
	self.Default_Gray = self.shaders["Default_Gray"];-- 置灰shader
	self.PSD2UGUI_SPLIT_ALPHA = self.shaders["PSD2UGUI ICON SPLIT ALPHA"];
	self.PSD2UGUI_SPLIT_ALPHA_GREY = self.shaders["PSD2UGUI ICON SPLIT ALPHA GREY"];
	self.UiObj = self.shaders["UiObj"];
	self.UiObj_Mask = self.shaders["UiObj_Mask"];
end