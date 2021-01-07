using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

public class AppConst {
    public const int PlayerMode = 2;                           //1:发布模式模式，2：开发模式
    public const bool LuaByteMode = false;                       //Lua字节码模式-默认关闭 
    public const int GameFrameRate = 30;                        //游戏帧频

    public const string AppName = "LuaFramework";               //应用程序名称
    public const string LuaTempDir = "luaTemp/";                //临时目录
    public const string ExtName = ".unity3d";                   //素材扩展名
    public const string AssetDir = "StreamingAssets";           //素材目录 

    public static string Version = "1.0";

    public static string PcLuaPath = "";
    public static string PcResPath = "";
    public static string PcLuaFramework = "";

    public static string FrameworkRoot {
        get {
            return Application.dataPath + "/" + AppName;
        }
    }
}
