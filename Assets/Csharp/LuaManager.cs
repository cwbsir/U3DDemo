using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using UnityEditor;
using System;
using System.IO;
using UnityEngine.UI;
using ICSharpCode.SharpZipLib.Zip;

public class LuaManager:MonoBehaviour
{
    private LuaState lua;
    private LuaLooper luaLooper;
    private LuaFunction gameTickFunc;
    private LuaResLoader luaResLoader;
    public static LuaManager instance;

    void Awake()
    {
        if(Application.isMobilePlatform)
        {
            StartCoroutine(OnExtractCodeZip());
        }
        else
        {
            InitLua();
        }
    }

    IEnumerator OnExtractCodeZip()
    {   
        Debug.Log("OnExtractCodeZip00");
        string codeZipPath = Application.streamingAssetsPath + "/lua.zip";
        string outfile = Application.persistentDataPath + "/lua.zip";
        //如果之前已从包内拿出代码zip，则直接进入解压环节
        if (File.Exists(outfile))
        {   //解压资源
            Debug.Log("OnExtractCodeZip11");
            UnZipResource();
        }
        else
        {
            Debug.Log("OnExtractCodeZip22");
            //安卓不支持File.Exists查询包内文件，只能用WWW尝试读取
            if (Application.platform == RuntimePlatform.Android)
            {
                Debug.Log("OnExtractCodeZip333");
                //安卓不需要将代码打为zip
                WWW www = new WWW(codeZipPath);
                yield return www;
                //读取出的文件长度若为0则表示不存在该文件，走默认流程，否则进入解压环节
                if (www.isDone && www.bytes.Length > 0)
                {
                   File.WriteAllBytes(outfile, www.bytes);
                   UnZipResource();//解压资源
                }
                else
                {
                    CheckExtractGameLua();
                }
                
                yield return 0;
            }
            else
            {
                if (File.Exists(codeZipPath))
                {
                    File.Copy(codeZipPath, outfile, true);
                    UnZipResource();//解压资源
                }
                else
                {
                    CheckExtractGameLua();
                }
                
            }
        }
        yield return new WaitForEndOfFrame();
    }

    public void CheckExtractGameLua()
    {   
        Debug.Log("CheckExtractGameLua11");
        string dir = Application.persistentDataPath + "/gamelua";
        bool isExists = Directory.Exists(dir) && File.Exists(dir + "/Main.lua") && File.Exists(dir + "/GameConfig.lua");
        if (isExists)
        {
            InitLua();
        }
        else
        {
            StartCoroutine(OnExtractGameLua());
        }
       
    }

    public void UnZipResource()
    {
        Debug.Log("UnZipResource00");
        string dir = Application.persistentDataPath + "/lua";
        bool isExists = Directory.Exists(dir);
        if (isExists)
        {
            Debug.Log("UnZipResource11");
            CheckExtractGameLua();
        }
        else
        {
            Debug.Log("UnZipResource22");
            UnLuaZip(Application.persistentDataPath + "/lua.zip", Application.persistentDataPath);
        }
    }


    IEnumerator OnExtractGameLua()
    {
        string dir = Application.persistentDataPath + "/gamelua";
        if (!Directory.Exists(dir))
        {
            Directory.CreateDirectory(dir);
        }

        string infile = Application.streamingAssetsPath + "/gamelua/Main.lua";
        string outfile = dir + "/Main.lua";
        if (!File.Exists(outfile))
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                WWW www = new WWW(infile);
                yield return www;
                if (www.isDone)
                {
                    Debug.Log("正在解包文件:>" + infile);
                    File.WriteAllBytes(outfile, www.bytes);
                }
                yield return 0;
            }
            else 
            {
                Debug.Log("正在解包文件:>" + infile);
                File.Copy(infile, outfile, true);
            }
            yield return new WaitForEndOfFrame();
        }

        infile = Application.streamingAssetsPath + "/gamelua/GameConfig.lua";
        outfile = dir + "/GameConfig.lua";
        if (!File.Exists(outfile))
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                WWW www = new WWW(infile);
                yield return www;
                if (www.isDone)
                {
                    Debug.Log("正在解包文件:>" + infile);
                    File.WriteAllBytes(outfile, www.bytes);
                }
                yield return 0;
            }
            else 
            {
                Debug.Log("正在解包文件:>" + infile);
                File.Copy(infile, outfile, true);
            }
            yield return new WaitForEndOfFrame();
        }
        InitLua();
    }

    public void InitLua()
    {
        luaLooper = new LuaLooper();
        luaResLoader = new LuaResLoader();

        instance = this;
        lua = new LuaState();
        lua.OpenLibs(LuaDLL.luaopen_pb);
        lua.OpenLibs(LuaDLL.luaopen_bit);
        lua.OpenLibs(LuaDLL.luaopen_lpeg);
        lua.OpenLibs(LuaDLL.luaopen_socket_core);
        lua.LuaSetTop(0);
        
        LuaBinder.Bind(lua);
        DelegateFactory.Init();
        LuaCoroutine.Register(lua,this);

        if(Application.isMobilePlatform)
        {
            lua.AddSearchPath(Application.persistentDataPath+"/gamelua");
            lua.AddSearchPath(Application.persistentDataPath+"/lua"); 
        }
        else
        {
            //发布模式
            if(AppConst.PlayerMode == 1)
            {   
                lua.AddSearchPath(Application.streamingAssetsPath+"/gamelua");
                lua.AddSearchPath(Application.streamingAssetsPath+"/lua"); 
            }
            else
            {     
                lua.AddSearchPath(Application.dataPath + "/Lua");     
                // lua.AddSearchPath(Application.dataPath + "/ToLua");
            }
        }


        Debug.Log("Application.persistentDataPath:"+Application.persistentDataPath);

        string tagLuaPath = Application.persistentDataPath+"/gamelua/Main.lua";
       if(System.IO.File.Exists(tagLuaPath))
        {
           Debug.Log("文件"+tagLuaPath+"存在");
        }
        else
        {
            Debug.Log("文件"+tagLuaPath+"不存在");
        }

        lua.Start();
        lua.DoString("print('hello world')");

        try
        {
            Debug.Log("#############Enter#####Game.lua##########");
            lua.DoFile("Main.lua");
            LuaFunction main = lua.GetFunction("Main");
            main.Call(gameObject);
            main.Dispose();
            main = null;
        }
        catch (LuaException e)
        {
            // Game.lua报错，删除可写目录下文件，重启，重新包里解压出来
            Debug.Log("######Game.lua####ERROR###lua文件出错,删除解压重启#####"+e);
            // deletFiles();
            // 重启程序
            // UnityEngine.SceneManagement.SceneManager.LoadScene("RestartScene");
            return;
        }

        // gameTickFunc = lua.GetFunction("gameTick");
    }

    void Update()
    {
        // gameTickFunc.Call(gameObject);
    }

    public void LuaDoString(string luStr)
    {
        lua.DoString(luStr);
    }

    public void DoFile(string filename) {
        lua.DoFile(filename);
    }

    public object[] CallFunction(string funcName, params object[] args) {
        LuaFunction func = lua.GetFunction(funcName);
        if (func != null) {
            return func.LazyCall(args);
        }
        return null;
    }

    public void LuaGC() {
        lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
    }

    public void UnLuaZip(string zipFilePath, string unZipDir = "")
    {
        Debug.Log("UnLuaZip00");
        //解压文件夹为空时默认与压缩文件同一级目录下，跟压缩文件同名的文件夹  
        if (unZipDir == string.Empty)
        {
            unZipDir = Path.GetDirectoryName(zipFilePath);
        }
        Debug.Log("UnLuaZip11:"+unZipDir+","+zipFilePath);
        if (!unZipDir.EndsWith("/"))
            unZipDir += "/";
        if (!Directory.Exists(unZipDir))
            Directory.CreateDirectory(unZipDir);

        using (var s = new ZipInputStream(File.OpenRead(zipFilePath)))
        {
            ZipEntry theEntry;
            while ((theEntry = s.GetNextEntry()) != null)
            {
                string directoryName = Path.GetDirectoryName(theEntry.Name);
                string fileName = Path.GetFileName(theEntry.Name);
                if (!string.IsNullOrEmpty(directoryName))
                {
                    Directory.CreateDirectory(unZipDir + directoryName);
                }
                if (fileName != String.Empty)
                {
                    using (FileStream streamWriter = File.Create(unZipDir + theEntry.Name))
                    {
                        int size;
                        byte[] data = new byte[2048];
                        while (true)
                        {
                            size = s.Read(data, 0, data.Length);
                            if (size > 0)
                            {
                                streamWriter.Write(data, 0, size);
                            }
                            else
                            {
                                break;
                            }
                        }
                    }
                }
            }
            CheckExtractGameLua();
        }
    }

    public void Close() {
        lua.Dispose();
        lua = null;

        // gameTickFunc.Dispose();
        // gameTickFunc = null;
    }
}
