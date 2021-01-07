SpriteSheetInfo = class("SpriteSheetInfo");

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