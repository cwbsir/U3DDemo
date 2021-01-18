CameraManager = class("CameraManager");

function CameraManager:ctor()
	self.uiCamera = nil;
	self.uiTransform = nil;
		
    self.angleX = 33;
    self.angleY = 135;
	self._focusPos = nil;
	self._tmpVector3 = nil;
end

function CameraManager:init()
	self._tmpVector3 = Vector3.zero;

	local cameraGo = UnityEngine.GameObject("MainCamera");
	UnityEngine.Object.DontDestroyOnLoad(cameraGo);
	self.mainCamera = cameraGo:AddComponent(typeof(UnityEngine.Camera));
	self.mainCamera.clearFlags = UnityEngine.CameraClearFlags.Depth;
	self.mainCamera.orthographic = false;
	self.mainCamera.cullingMask = globalConst.layerConst.DefaultMask + globalConst.layerConst.IgnoreRaycastMask +
    							globalConst.layerConst.WaterMask + globalConst.layerConst.TerrainMask +
    							globalConst.layerConst.WallMask + globalConst.layerConst.ActorMask;
	self.mainCamera.allowHDR = false;
	self.mainCamera.useOcclusionCulling = false;
	self.mainCamera.allowMSAA = false;
	self.mainCamera.depth = 1;
	self.mainCamera.fieldOfView = 53;
	self.mainCamera.nearClipPlane = 0.3;
	self.mainCamera.farClipPlane = 50;
	self.mainTransform = cameraGo.transform;
	self._tmpVector3:Set(self.angleX,self.angleY,0);
	self.mainTransform.localEulerAngles = self._tmpVector3;

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

function CameraManager:setFocus(focusPos)
    self._focusPos = focusPos;
    if self._focusPos ~= nil then
    	local forward = self.mainTransform.forward;
        self._tmpVector3:Set(forward.x,forward.y,forward.z);
        self._tmpVector3:Mul(8.2);
        self._tmpVector3:Set(self._focusPos.x - self._tmpVector3.x,self._focusPos.y - self._tmpVector3.y,self._focusPos.z - self._tmpVector3.z);
        self.mainTransform.position = self._tmpVector3;
    end
end

function CameraManager:restart()
	GameObject.Destroy(self.uiCamera.gameObject);
end