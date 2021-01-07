using UnityEngine;

public class PSDConst
{
	// 文本修复高度
	public const float TEXT_FIX_Y = 6;
	public const float TEXTFIELD_FIX_H = 3;
	//图集打包
	public const bool ATLAS_ISALPHA = true;

	public static string MD5_PATH = Application.dataPath+"/Resources/md5.txt";

	public static string GUI_PATH = "Assets/Resources/GUI/";
	public static string OUT_PATH = "Assets/Resources/OutPic/";
	public static string ATLAS_PATH_COMMON = "Assets/Resources/GUI/UICommon/UICommon.png";
	public static string PSD_PATH = Application.dataPath+"/Resources/PSD/PSD/";
	public static string PSD_OUT_PATH = Application.dataPath+"/Resources/PSD/PSDOutput/";
	public static string UI_COMMON_PATH = Application.dataPath+"/Resources/PSD/PSD/UICommon.psd";
	

	public static string ATLAS_TEXTURE_EXE = "D:/TexturePacker/bin/TexturePacker.exe";

	public static string Psd2UI_EXE_PATH = Application.dataPath + "/Resources/PSD/Psd2UI.exe";

	public static string SHADER_PATH_SPLIT_ALPHA = "Assets/Resources/Shader/PSD2UGUI/PSD2UGUI_SPLIT_ALPHA.shader";

	//默认字体资源
	public static string FONT_PATH = "Assets/Resources/Fonts/yhFont.ttf";

	//锚点类型	
	public static Vector2 PIVOTPOINT0 = new Vector2(0.5f,0.5f);// center
	public static Vector2 PIVOTPOINT1 = new Vector2(0.0f,1.0f);// topLeft
	public static Vector2 PIVOTPOINT2 = new Vector2(0.5f,1.0f);// topCenter
	public static Vector2 PIVOTPOINT3 = new Vector2(1.0f,1.0f);// topRight
	public static Vector2 PIVOTPOINT4 = new Vector2(0.0f,0.5f);// centerLeft
	public static Vector2 PIVOTPOINT5 = new Vector2(1.0f,0.5f);// centerRight
	public static Vector2 PIVOTPOINT6 = new Vector2(0.0f,0.0f);// bottomLeft
	public static Vector2 PIVOTPOINT7 = new Vector2(1.0f,0.0f);// bottomRight
	public static Vector2 PIVOTPOINT8 = new Vector2(0.5f,0.0f);// bottomCenter

	public static string GetPrefabPathByName(string name)
	{
		return "Assets/Prefabs/"+ name + ".prefab";
	}
}