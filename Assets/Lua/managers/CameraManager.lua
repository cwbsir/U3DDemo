CameraManager = class("CameraManager");

function CameraManager:ctor()
	self.uiCamera = nil;
	
	self._tmpVector3 = nil;
end

function CameraManager:init()
	self._tmpVector3 = Vector3.zero;

	local uiGo = UnityEngine.GameObject("UICamera");
	UnityEngine.Object.DontDestroyOnLoad(uiGo);
	self.uiCamera = uiGo:AddComponent(typeof(UnityEngine.Camera));
	self.uiCamera.clearFlags = UnityEngine.CameraClearFlags.Depth;
	self.uiCamera.orthographic = true;
	self.uiCamera.cullingMask = globalConst.layerConst.UIMask;
	self.uiCamera.allowHDR = false;
	self.uiCamera.useOcclusionCulling = false;
	self.uiCamera.allowMSAA = false;
	self.uiCamera.depth = 3;
	self._tmpVector3:Set(1000, 1000, 1000);
	self.uiTransform = uiGo.transform;
	self.uiTransform.position = self._tmpVector3;
end

function CameraManager:restart()
	GameObject.Destroy(self.uiCamera.gameObject);
end