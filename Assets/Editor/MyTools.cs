using System.IO;
using UnityEditor;
using UnityEngine;

public class MyTools : MonoBehaviour
{
    [MenuItem("MyTools/发布所有资源")]
    public static void BuildAllAssetBundles()
    {
        Debug.Log("BuildAllAssetBundles");
        string assetBundleDirectory = "Assets/StreamingAssets";
        if (!Directory.Exists(assetBundleDirectory))
        {
            Directory.CreateDirectory(assetBundleDirectory);
        }

        // BuildPipeline.BuildAssetBundles(assetBundleDirectory, BuildAssetBundleOptions.None, BuildTarget.Android);
        BuildPipeline.BuildAssetBundles(assetBundleDirectory, BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows64);
    }

    [MenuItem("MyTools/生成ImportClient.lua")]
    public static void BuildImportClient()
    {
        System.Diagnostics.Process proc = new System.Diagnostics.Process();
        proc.StartInfo.FileName = Application.dataPath + "/../Tools/ImportClient.bat";
        proc.StartInfo.CreateNoWindow = true;
        proc.Start();
        proc.WaitForExit();

        Debug.Log("!!!!!!!ImportClient.lua重新生成成功!!!!!!!!!!!");
    }

    [MenuItem("MyTools/生成模板表")]
    public static void BuildTemplates()
    {
        System.Diagnostics.Process proc = new System.Diagnostics.Process();
        proc.StartInfo.FileName = Application.dataPath + "/Template/mixcodeLua.bat";
        proc.StartInfo.CreateNoWindow = true;
        proc.Start();
        proc.WaitForExit();

        string templateFile = Application.dataPath + "/Template/ky203.txt";
        if(File.Exists(templateFile))
        {
            string targetFile = Application.dataPath + "/StreamingAssets/ky203.txt";
             if(File.Exists(targetFile)){
                File.Delete(targetFile);
             }
            File.Copy(templateFile,targetFile);
        }
        else
        {
            Debug.Log("不存在文件："+templateFile);
        }
        Debug.Log("!!!!!!!模板表生成成功!!!!!!!!!!!");
    }

    [MenuItem("MyTools/切换模式/发布模式")]
   public static void ChangeToDocMode()
    {
        System.Diagnostics.Process proc = new System.Diagnostics.Process();
        proc.StartInfo.FileName = Application.dataPath + "/../Tools/changeToDocMode.bat";
        proc.StartInfo.CreateNoWindow = true;
        proc.Start();
        proc.WaitForExit();
        AssetDatabase.Refresh();
    }
     [MenuItem("MyTools/切换模式/开发模式")]
    public static void ChangeToTrunkMode()
    {
        System.Diagnostics.Process proc = new System.Diagnostics.Process();
        proc.StartInfo.FileName = Application.dataPath + "/../Tools/changeToTrunkMode.bat";
        proc.StartInfo.CreateNoWindow = true;
        proc.Start();
        proc.WaitForExit();
        AssetDatabase.Refresh();
    }

    //混淆lua代码
    public static void MixCodeLua()
    {
        System.Diagnostics.Process proc = new System.Diagnostics.Process();
        proc.StartInfo.FileName = Application.dataPath + "/../Tools/mixcodeLua.bat";
        proc.StartInfo.CreateNoWindow = true;
        proc.Start();
        proc.WaitForExit();

        string luaPath = Application.dataPath + "/lua/targetLuaFile.txt";
        string bakPath = Application.dataPath + "/../Tools/out/targetLuaFile.txt";
        if (File.Exists(luaPath))
        {
            if (File.Exists(bakPath))
            {
                File.Delete(bakPath);
            }
            File.Copy(luaPath,bakPath);
            File.Delete(luaPath);
        }
        Debug.Log("!!!!!!!混淆代码完毕!!!!!!!!!!!");
    }

    static void CreateAllLuaAb(BuildTarget target,bool isOneKey = false)
    {
        string streamPath = Application.dataPath + "/StreamingAssets";
        // if(target == BuildTarget.Android)
        // {
        //     streamPath = Application.dataPath + "/StreamingAssets_android";
        // }
        // else if(target == BuildTarget.iOS)
        // {
        //     streamPath = Application.dataPath + "/StreamingAssets_ios";
        // }


        if(!Directory.Exists(streamPath + "/gamelua"))
        {
            Directory.CreateDirectory(streamPath + "/gamelua");
        }
        string resLuaPath = Application.dataPath + "/Lua/GameConfig.lua";
        string tagLuaPath = streamPath + "/gamelua/GameConfig.lua";
        if(File.Exists(tagLuaPath))
        {
            File.Delete(tagLuaPath);
        }
        File.Copy(resLuaPath, tagLuaPath);

        resLuaPath = Application.dataPath + "/Lua/Main.lua";
        tagLuaPath = streamPath + "/gamelua/Main.lua";
        if(File.Exists(tagLuaPath))
        {
            File.Delete(tagLuaPath);
        }
        File.Copy(resLuaPath, tagLuaPath);

        string luaPath = Application.dataPath + "/Lua/targetLuaFile.txt";
        string bakPath = Application.dataPath + "/../Tools/out/targetLuaFile.txt";
        if (File.Exists(bakPath))
        {
            if (File.Exists(luaPath))
            {
                File.Delete(luaPath);
            }
            File.Copy(bakPath,luaPath);
            
            AssetBundleBuild[] builds = new AssetBundleBuild[1];
            string[] list = new string[1];
            list[0] = "Assets/Lua/targetLuaFile.txt";
            builds[0].assetNames = list;
            builds[0].assetBundleName = "luafile";

            Debug.Log("开始打包了。。。。。"+streamPath);
            BuildPipeline.BuildAssetBundles(streamPath, builds, BuildAssetBundleOptions.ForceRebuildAssetBundle, target);

            AssetDatabase.Refresh();
            // 要先刷新在删除，否则会当增量更新，不会强制生成
            File.Delete(luaPath);

            if(!isOneKey)
            {
                // copyToPublicDoc();
                EditorUtility.DisplayDialog("完成", "luafile打AB包并发布成功！", "确定");
            }
        }
        else
        {
            EditorUtility.DisplayDialog("错误", "找不到targetLuaFile.txt文件！", "确定");
        }
    }

    [MenuItem("MyTools/发布lua代码")]
    public static void oneKeyWinPublic()
    {   
        BuildImportClient();
        ChangeToDocMode();
        MixCodeLua();
        // CreateAllLuaAb(BuildTarget.Android,false);
        CreateAllLuaAb(BuildTarget.StandaloneWindows64,false);
        
        ChangeToTrunkMode();
    }
}   
