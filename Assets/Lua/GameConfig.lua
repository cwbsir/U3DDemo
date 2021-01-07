GameConfig = class("GameConfig");

function GameConfig:ctor()

end

function GameConfig:isWin()
    return not self:isAndroid() and not self:isIOS();
end

function GameConfig:isAndroid()
    return UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android;
end

function GameConfig:isIOS()
    return UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer;
end

function GameConfig:getResFoldPath()
	do return UnityEngine.Application.streamingAssetsPath; end

end