StartController = class("StartController");

function StartController:ctor()
	self.mainMenu = nil;
end

function StartController:startLoad()
	self.lastTime = 0;
	-- print("Application.dataPath",UnityEngine.Application.dataPath);
	-- print("Application.temporaryCachePath",UnityEngine.Application.temporaryCachePath);
	-- print("Application.streamingAssetsPath",UnityEngine.Application.streamingAssetsPath);
	-- print("Application.persistentDataPath",UnityEngine.Application.persistentDataPath);

	--0:assetbundle,1:text,2:bytes,3:texture
	self.loadResList = {};
	table.insert(self.loadResList,{0,"shader.u"})
	table.insert(self.loadResList,{0,"font.u","yhFont.ttf"})
	table.insert(self.loadResList,{0,"StreamingAssets","AssetBundleManifest"})
	table.insert(self.loadResList,{0,globalManager.pathManager:getCommonUIPath()})
	table.insert(self.loadResList,{0,globalManager.pathManager:getCommonItemPrefabPath()})
	self.resCompleteCount = 0;

	 --先加载模板表，再加载资源
	self:loadTemplate();
end

function StartController:loadTemplate()
	if(self._templateComplete)then return; end
	print("开始加载模板数据");
	globalManager.loaderManager:loadBytes("ky203.txt",self.templateLoadComplete,self);
end
function StartController:templateLoadComplete(abName,assetName,bytes)
	if bytes ~= nil then
		print("template load complete");
		self.mubanTime = os.clock();
		globalManager.templateParser:start(bytes, self.templateParseComplete, self);
	end
end

function StartController:templateParseComplete()
	print("template parse complete");
	print("ooooooooooooooooooooo解析模板表耗时：",os.clock() - self.mubanTime);
	self._templateComplete = true;
	self:loadRes();
end

function StartController:loadRes()
	for i=1,#self.loadResList do
		local data = self.loadResList[i];
		--加载ab包
		if data[1] == 0 then
			globalManager.loaderManager:loadAB(data[2],data[3],self.loadResComplete,self);
		end
	end
end

function StartController:loadResComplete(abName,assetName,abContent,asset)
	if abName == "shader.u" then
		globalConst.shaderType:init(abContent);
	elseif abName == "font.u" then
		globalData.defaultFont = abContent:LoadAsset(assetName);
	elseif abName == "StreamingAssets" then
		globalManager.loaderManager:setABManifest(asset);
	elseif abName == globalManager.pathManager:getCommonUIPath() then
		globalData.uiPrefabs = parseABContent(abContent);
	elseif abName == globalManager.pathManager:getCommonItemPrefabPath() then
		globalData.commonItemPrefabs = parseABContent(abContent);
	end

	self.resCompleteCount = self.resCompleteCount + 1;
	if self.resCompleteCount >= #self.loadResList then
		self:startGame();
	end
end

function StartController:startGame()
	if self.mainMenu == nil then
		self.mainMenu = MainMenu:new();
	end
	self.mainMenu:initView();
	globalManager.eventDispatcher:dispatchEvent(globalConst.eventType.Scene_MapInfo_Complete,"20040");
	
	-- local image = globalManager.kCreator:createImage();	
	-- -- image:loadFromSpriteSheet("callpanel.u","callHeroImg1");
	-- image:loadOutPic("callpanel-choukabg.png.u","callPanel-choukabg");
	-- image:setPosition(globalManager.uiManager.PANEL_WIDTH/2,-globalManager.uiManager.PANEL_HEIGHT/2);
	-- -- image:addTouchCallBack(self.btnClickHandler,self);
	-- image:setParent(globalManager.uiManager.mainTransform);

	-- local label = globalManager.kCreator:createRichLabel();
	-- label:setPosition(100,-50)
	-- label:setString("你是&#6$602$2$<color=#fb5657>没下划线点击</color>$81$0$0$0#&哈&#6$602$3$<color=#fb5657>下划线点击</color>$91$0$0$0#&吗");
	-- label:setParent(globalManager.uiManager.mainTransform);

	-- local scrollView = globalManager.kCreator:createScrollView("scrollView");
	-- image:addNode(scrollView);
	-- scrollView:setGap(5,5);
	-- scrollView:setCallBacks(self.createItemCb,self.getItemIdCb,self.getItemLenCb,self);
	-- scrollView:setFormat(1,100,100);
end

function StartController:createItemCb(index)
	-- print("createItemCb",index);
	return globalManager.kCreator:createImage();
end

function StartController:getItemIdCb(index)
	return index;
end

function StartController:getItemLenCb(index)
	return 10;
end

function StartController:btnClickHandler(sender)
	print("StartController:btnClickHandlerStartController:btnClickHandler");
end