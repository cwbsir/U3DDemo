if jit and jit.off then jit.off() end

setmetatableindex = function(t, index) 
    local mt = getmetatable(t);
    if(not mt)then mt = {}; end
    if(not mt.__index)then
        mt.__index = index;
        setmetatable(t, mt);
    elseif(mt.__index ~= index)then
        setmetatableindex(mt, index);
    end
end

function class(classname, super)
    local cls = {__cname = classname};
 
    cls.super = super;
    cls.__index = cls;
    if(super)then
        setmetatable(cls, {__index = cls.super});
    end

    cls.new = function(_,...)
        local instance = {};
        setmetatableindex(instance, cls);
        instance.class = cls;
        if(instance.ctor ~= nil)then
            instance:ctor(...);
        end
        return instance;
    end

    return cls;
end


require("GameConfig");

gameConfig = GameConfig:new();

--加载luafile
function loadLuafile(gameObject)
	local path = UnityEngine.Application.streamingAssetsPath.."/luafile";
	-- if gameConfig:isAndroid() == true then
	-- 	path = "file://"..path;
	-- end
	-- if gameConfig:isIOS() == true then
	-- 	path = "file://"..path;
	-- end

	local download = UnityEngine.WWW(path);
	Yield(download);

	if(download.error ~= "" and download.error ~= nil)then
		print("error:",download.error);
		return;
	else
		local asset = download.assetBundle:LoadAsset("targetLuaFile.txt");
		local luaMgr = gameObject:GetComponent(typeof(LuaManager));
		luaMgr:LuaDoString(asset.text);
		download.assetBundle:Unload(true);
	end
	download:Dispose();
	download = nil;

	start(); 
end


globalData = nil;
globalConst = nil;
globalManager = nil;

--游戏逻辑开始
function start()
	globalData = GlobalData:new();
	globalConst = GobalConst:new();
	globalManager = GlobalManager:new();


	globalConst:init();
	globalManager:init();

	globalData.systemDateInfo:start();
	
	startController = StartController:new();
	startController:startLoad();
end

--主入口函数。从这里开始lua逻辑
function Main(gameObject)

	print("main AppConst.PlayerMode",AppConst.PlayerMode);
	--发布模式
	if AppConst.PlayerMode == 1 then
		StartCoroutine(function() loadLuafile(gameObject); end);
	-- 开发模式
	elseif AppConst.PlayerMode == 2 then
		require("ImportClient");
		start(); 
	end

	print("logic start");
end

function onGuiFunc()
	globalManager.tickManager:update(deltaTime)
end

function gameTick(deltaTime)
	-- print("tickFunc deltaTime=",deltaTime);
	if globalManager ~= nil then
		globalManager.tickManager:update(deltaTime)
	end
	
end

function gameTickFunc(deltaTime)
	-- print("deltaTime=",deltaTime);
end


