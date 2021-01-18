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

	self.moduleControllers = nil;

	self.eventDispatcher = nil;

	self.spriteSheetList = nil;
end

function GlobalManager:init()

	self.eventDispatcher = EventDispatcher:new();

	self.kCreator = KCreator:new();
	self.tickManager = TickManager:new();
	self.poolManager = PoolManager:new();
	self.pathManager = PathManager:new();
	self.loaderManager = LoaderManager:new();
	self.templateParser = TemplateParser:new();

	self.sceneModule = SceneModule:new();


	self.uiManager = UIManager:new();
	self.cameraManager = CameraManager:new();
	self.triggerManager = TriggerManager:new();
	self.spriteSheetList = SpriteSheetList:new();

	self.cameraManager:init();
	self.uiManager:init();
end