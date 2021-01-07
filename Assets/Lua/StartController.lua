StartController = class("StartController");

function StartController:startLoad()
	self.mubanTime = 0;
	-- print("Application.dataPath",UnityEngine.Application.dataPath);
	-- print("Application.temporaryCachePath",UnityEngine.Application.temporaryCachePath);
	-- print("Application.streamingAssetsPath",UnityEngine.Application.streamingAssetsPath);
	print("Application.persistentDataPath",UnityEngine.Application.persistentDataPath);

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
	self:loadShaders();
end

function StartController:loadShaders()
	globalManager.loaderManager:loadAsset("shader.u",nil,self.loadShadersComplete,self);
end

function StartController:loadShadersComplete(abName,assetName,abContent)
	globalConst.shaderType:init(abContent);

	globalManager.loaderManager:loadAsset("font.u","yhFont.ttf",self.loadFontComplete,self);
end

function StartController:loadFontComplete(abName,assetName,abContent)
	globalData.defaultFont = abContent:LoadAsset(assetName);
	
	globalManager.loaderManager:loadAsset(globalManager.pathManager:getCommonUIPath(),nil,self.loadUICommonComplete,self);
end

function StartController:loadUICommonComplete(abName,assetName,abContent)
	globalData.uiPrefabs = parseABContent(abContent);

	globalManager.loaderManager:loadAsset(globalManager.pathManager:getCommonItemPrefabPath(),nil,self.loadCommonItemUIComplete,self);
end

function StartController:loadCommonItemUIComplete(abName,assetName,abContent)
	globalData.commonItemPrefabs = parseABContent(abContent);

	self:startGame();
end

function StartController:startGame()
	print("startGame");

	if self._gameScene == nil then
		self._gameScene = GameScene:new();
	end

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