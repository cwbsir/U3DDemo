SpriteSheetList = class("SpriteSheetList");

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
	-- print("SpriteSheetList:loadSprite",abName,spriteName);
	local spriteSheetInfo = self.list[abName];
	if spriteSheetInfo ~= nil then
		local sprite = spriteSheetInfo:getSprite(spriteName);
		if sprite == nil then
			print("##########ERROR!!不存在Sprite##########",spriteName);
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
			globalManager.loaderManager:loadAB(abName,nil,self.spriteSheetLoadComplete,self);
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
	print("spriteSheetLoadComplete",abName);
	if abContent == nil then return; end
	self:addSheet(abName,abContent);
	print("spriteSheetLoadComplete11",abName);
	local waitingLoadSheet = self.waitingLoadSheetDic[abName];
	if waitingLoadSheet ~= nil then
		print("spriteSheetLoadComplete22",abName);
		local sheetInfo = self.list[abName];
		local material = sheetInfo.material;
		for k,v in pairs(waitingLoadSheet) do
			local spriteName,list = k,v;
			local len = #list;
			print("spriteSheetLoadComplete33",spriteName,len);
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