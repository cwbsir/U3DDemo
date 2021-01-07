ColorConst = class("ColorConst")

function ColorConst:ctor()
	self.white = clone(UnityEngine.Color.white);
	self.black = clone(UnityEngine.Color.black);
	self.clear = clone(UnityEngine.Color.clear);
	self.gray = clone(UnityEngine.Color.gray);
	self.green = clone(UnityEngine.Color.green);
	self.blue = clone(UnityEngine.Color.blue);
	self.empty = Color(0, 0, 0, 0);

	self.cardSelectColor = self:newColor(132,124,124);

	--米色标题
	self.titleColor = self:newColor(246,255,210);
	--格子数量白色
	self.countWhite = self:newColor(240,245,222);
	--按钮标题咖啡色
	self.btnColor1 = self:newColor(150,86,12);
	--按钮标题绿色
	self.btnColor2 = self:newColor(79,100,31);
	--正常底

	self.bright_firstColor = self:newColor(67,85,81);
	self.bright_secondColor = self:newColor(108,124,120);
	self.bright_green = self:newColor(105,168,43);
	self.bright_blue = self:newColor(78,145,255);
	self.bright_purple = self:newColor(211,90,219);
	self.bright_orange = self:newColor(255,159,9);
	self.bright_red = self:newColor(251,86,87);

	self.bright_firstColorStr = "#435551";
	self.bright_secondColorStr = "#6c7c78";
	self.bright_greenStr = "#69a82b";
	self.bright_blueStr = "#4e91ff";
	self.bright_purpleStr = "#d35adb";
	self.bright_orangeStr = "#ff9f09";
	self.bright_redStr = "#fb5657";

	self.dark_firstColor = self:newColor(230,237,203);
	self.dark_secondColor = self:newColor(182,205,140);
	self.dark_green = self:newColor(145,239,90);
	self.dark_blue = self:newColor(89,183,255);
	self.dark_purple = self:newColor(234,82,252);
	self.dark_orange = self:newColor(251,184,40)
	self.dark_red = self:newColor(255,84,78);

	self.dark_firstColorStr = "#e6edcb";
	self.dark_secondColorStr = "#b6cd8c";
	self.dark_greenStr = "#91ef5a";
	self.dark_blueStr = "#59b7ff";
	self.dark_purpleStr = "#ea52fc";
	self.dark_orangeStr = "#fbb828";
	self.dark_redStr = "#ff544e";

	self.qualityColorList = {self.bright_green,self.bright_blue,self.bright_purple,self.bright_purple,self.bright_orange,self.bright_orange,self.bright_red,self.bright_red};
	self.qualityColorStrList = {self.bright_greenStr,self.bright_blueStr,self.bright_purpleStr,self.bright_purpleStr,self.bright_orangeStr,self.bright_orangeStr,self.bright_redStr,self.bright_redStr};
	--暗底品质颜色
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
	return KYstringFormat("<color={1}>{2}</color>",color,str);
end