GlobalManager = class("GlobalManager");

function GlobalManager:ctor()
	self.kCreator = nil;
	self.uiManager = nil;
	self.poolManager = nil;
	self.tickManager = nil;
	self.pathManager = nil;
	self.loaderManager = nil;
	self.cameraManager = nil;
	self.triggerManager = nil;
	self.gameEventDispatcher = nil;

	self.spriteSheetList = nil;
end

function GlobalManager:init()

	self.kCreator = KCreator:new();
	self.tickManager = TickManager:new();
	self.poolManager = PoolManager:new();
	self.pathManager = PathManager:new();
	self.loaderManager = LoaderManager:new();
	self.templateParser = TemplateParser:new();

	self.gameEventDispatcher = EventDispatcher:new();

	self.uiManager = UIManager:new();
	self.cameraManager = CameraManager:new();
	self.triggerManager = TriggerManager:new();
	self.spriteSheetList = SpriteSheetList:new();

	self.cameraManager:init();
	self.uiManager:init();
end