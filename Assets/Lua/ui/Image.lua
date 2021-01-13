Image = class("Image",Node);

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

-- function Image:setImagePath(abName)
-- 	globalManager.loaderManager:loadTexture(abName,self.loadComplete,self);
-- end
-- function Image:loadComplete(abName)
--     local sprite = UnityEngine.Sprite.Create(texture,UnityEngine.Rect(0,0,texture.width,texture.height),Vector2(0, 0));
-- 	self:__setSprite(sprite);
-- 	self:setSize(texture.width,texture.height);
-- end

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
	-- 设置成透明，否则会白屏闪烁一下
	-- self:setColor(nil,0);
	globalManager.loaderManager:loadAB(abName,assetName,self.outPicLoadComplete,self);
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

--私有方法，仅限内部调用，外部请使用setSpriteName
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
		globalManager.loaderManager:removeAB(self._outAbName,self._outAssetName,self.outPicLoadComplete,self);
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