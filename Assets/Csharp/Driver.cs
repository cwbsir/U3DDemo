using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using UnityEditor;
using UnityEngine.UI;

public class Driver:MonoBehaviour
{
    private LuaState lua;
    private LuaManager luaManager;
    private LuaFunction tickFunc;
    private LuaFunction onGuiFunc;
    private LuaFunction fixedTickFunc;

    private float m_LastUpdateShowTime = 0f;    //上一次更新帧率的时间;

    public int targetFrameRate = 10;

    void Start()
    {   

        // //设置屏幕自动旋转， 并置支持的方向
        // Screen.orientation = ScreenOrientation.AutoRotation;
        // Screen.autorotateToLandscapeLeft = true;
        // Screen.autorotateToLandscapeRight = true;
        // Screen.autorotateToPortrait = false;
        // Screen.autorotateToPortraitUpsideDown = false;

        Debug.Log("Drive 屏幕Sceen宽高,"+UnityEngine.Screen.width+","+UnityEngine.Screen.height);

        //加载背景图
        // StartCoroutine(loadFirstBg());
        // initConsole();
        Debug.Log("PlayerMode="+AppConst.PlayerMode);
        // Debug.Log("Application.streamingAssetsPath="+Application.streamingAssetsPath);
        // Debug.Log("Application.persistentDataPath="+Application.persistentDataPath);
        gameObject.AddComponent<LuaManager>();
         // Debug.Log("Application.persistentDataPath=11111111111");
        m_LastUpdateShowTime = Time.realtimeSinceStartup;

    }

    IEnumerator loadFirstBg()
    {
        string sPath = Application.streamingAssetsPath + "/bg.jpg";
        if (Application.platform == RuntimePlatform.IPhonePlayer)
        {
            sPath = "file://" + sPath;
        }
        WWW www = new WWW(sPath);
        yield return www;

        Texture2D texture = www.texture;

        var uiGo = new GameObject("UICamera");
        UnityEngine.Object.DontDestroyOnLoad(uiGo);
        uiGo.AddComponent(typeof(UnityEngine.Camera));
        UnityEngine.Camera uiCamera = uiGo.GetComponent<UnityEngine.Camera>();
        var pos = new Vector3(1000, 1000, 1000);
        var uiTransform = uiGo.transform;
        uiTransform.position = pos;

        var canvasGo = new GameObject("UICanvas");
        UnityEngine.Object.DontDestroyOnLoad(canvasGo);
        canvasGo.AddComponent(typeof(UnityEngine.Canvas));
        UnityEngine.Canvas canvas = canvasGo.GetComponent<UnityEngine.Canvas>();
        canvas.renderMode = UnityEngine.RenderMode.ScreenSpaceCamera;
        canvas.worldCamera = uiCamera;
        canvas.scaleFactor = 1;
        canvas.sortingOrder = -100;
        canvas.planeDistance = 300;
        canvas.pixelPerfect = true;

        var imageGo = new GameObject("Image");
        UnityEngine.Object.DontDestroyOnLoad(imageGo);
        imageGo.AddComponent(typeof(UnityEngine.UI.Image));
        Image image = imageGo.GetComponent<UnityEngine.UI.Image>();
        RectTransform rect = imageGo.GetComponent<RectTransform>();
        Vector2 pivot1 = new Vector2(0.0f,1.0f);// topLeft
        // 总预设锚点再左上角(父锚点，锚点)
        Vector2 anchorP = pivot1;
        rect.anchorMin = pivot1;
        rect.anchorMax = pivot1;
        rect.offsetMin = new Vector2 (0.0f,0.0f);
        rect.offsetMax = new Vector2 (0.0f,0.0f);
        rect.sizeDelta = new Vector2 (texture.width, texture.height);


        var pos2 = new Vector3(563, -320, 0);
        imageGo.transform.position = pos2;
        imageGo.transform.SetParent(canvasGo.transform,false);

        
        Sprite sp = UnityEngine.Sprite.Create(texture, new Rect(0.0f, 0.0f, texture.width, texture.height), new Vector2(0.0f, 0.0f));
        image.sprite = sp;
    }

    void initConsole()
    {
        if (GameObject.Find("Console") == null)
        {
            GameObject console = new GameObject("Console");
            console.AddComponent<WinConsole>();
            GameObject.DontDestroyOnLoad(console);
        }
    }

    void Awake ()
    {
        Application.targetFrameRate = targetFrameRate;
    }

    // Update is called once per frame
    void Update()
    {
        float deltaTime = Time.realtimeSinceStartup - m_LastUpdateShowTime;
        LuaManager.instance.CallFunction("gameTick",gameObject);
        m_LastUpdateShowTime = Time.realtimeSinceStartup;
    }


    void FixedUpdate()
    {
        // fixedTickFunc.Call();
    }

    public void Close() {

    }
}
