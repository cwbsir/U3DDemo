using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;

public class ImageComponent
{
	// 初始化
	public static GameObject InitImageComponent (Children child, GameObject parentObj,string fileName)
	{
		// 获取属性
		var propertys = child.options.property.Split ('\r');
		var prop = new Property ();
		prop.DeserializeProperty (propertys);


		
		bool isCommon = false; // 是否使用公共图集
		string file_result = "";


		RectTransform parentRect = parentObj.GetComponent<RectTransform> ();

		/**
			外部图片：outpic
			公共图片：common
			面板独有：剩下的

		1.先判断是否为外部图片，预留空go，单独图集
		2.每次查询图集先从公共图集里查询
		3.剩下的加入面板独有图集
		*/

		// 构建图片控件
		string path = PSDConst.GetPrefabPathByName("Image");

		GameObject temp = AssetDatabase.LoadAssetAtPath(path,typeof(GameObject)) as GameObject; 
		GameObject gameObject = GameObject.Instantiate(temp) as GameObject;
		gameObject.name = child.name;
		gameObject.transform.SetParent(parentObj.transform,false);

		Image imgComponent = gameObject.GetComponent<Image>();

		// 设置图片控件位移及锚点信息
 		RectTransform rectTransform = gameObject.GetComponent<RectTransform>();

		// 设置锚点
		// Vector2 anchorP = new Vector2 (prop.anchors[0], prop.anchors[1]);
		// 默认中心的点
		Vector2 anchorP = PSDConst.PIVOTPOINT0;
		rectTransform.anchorMin = PSDConst.PIVOTPOINT1;
		rectTransform.anchorMax = PSDConst.PIVOTPOINT1;
		rectTransform.pivot = anchorP; 

		// RectTransform 根据锚点计算 x,y位置
		if (anchorP == PSDConst.PIVOTPOINT0)
		{ // 中间
			float x = child.options.x + (child.options.width / 2);
			float y = child.options.y + (child.options.height / 2);
			rectTransform.localPosition = new Vector3 (x, -y);

			rectTransform.sizeDelta = new Vector2 (child.options.width, child.options.height);
		}
		else//默认左上
		// else if (anchorP == PSDConst.PIVOTPOINT1) 
		{ // 左上
			float x = child.options.x;
			float y = child.options.y;
			rectTransform.localPosition = new Vector3 (x, -y);
			
			rectTransform.sizeDelta = new Vector2 (child.options.width, child.options.height);
		} 

		Sprite sprite = null;
		Material material = null;
		string[] link_split = child.options.link.Split ('#');
		string rootPath = (link_split.Length > 0) ? (link_split[0]) : "";
		string imgPath = (link_split.Length > 0) ? link_split[link_split.Length - 1] : "";
		string prefix = (imgPath.Split('/').Length > 1) ? imgPath.Split('/')[0] : "";
		string imgName = (imgPath.Split('/').Length > 0) ? imgPath.Split('/')[imgPath.Split('/').Length - 1] : "";
		imgName = Path.GetFileNameWithoutExtension (imgName);
		string atlasName = (prefix != "") ? (prefix + "-" + imgName) : (imgName);

		// 获取图集名称,先从公共图集中查询
		if (File.Exists (PSDConst.ATLAS_PATH_COMMON)) {
			sprite = AtlasManager.getSpriteForTextureP (PSDConst.ATLAS_PATH_COMMON, atlasName);
			// 加载材质
			material = AtlasManager.getMaterForAtlasPath(PSDConst.ATLAS_PATH_COMMON); 
			if (sprite != null) {
				isCommon = true;
			}
		}
		// Debug.Log ("$$$imgPath: "+imgPath+","+PSDConst.ATLAS_PATH_COMMON+","+atlasName);

		if (sprite == null) {
			isCommon = false;
			string tarPath = PSDConst.GUI_PATH + fileName + '/' + fileName + ".png";
			Debug.Log("tarPath====="+tarPath+","+fileName);
			// file_result = fileName;
			// if (fileName.Contains("Item")) {
			// 	string[] file_split = fileName.Split ('_');
			// 	for (int i = 0; i < file_split.Length; i++) {
			// 		if (file_split[i].Contains("Item")) {
			// 			file_result = fileName.Replace (("_"+file_split[i]),(""));
			// 			tarPath = PSDConst.GUI_PATH + file_result + '-' + file_result + ".png";
			// 		}
			// 	}
			// }
			if (File.Exists(tarPath)) {
				// Debug.Log ("!!!!:"+imgPath.Split('/').Length);
				Debug.Log ("###tarPath:"+tarPath+",atlasName="+atlasName);
				sprite = AtlasManager.getSpriteForTextureP (tarPath,atlasName);
			}
			else{
				Debug.Log ("File is not Exists:"+tarPath);
			}
			// 加载材质
			material = AtlasManager.getMaterForAtlasPath(tarPath); 

		}

        // 设置控件背景颜色（包含透明度）
        var colorR = 1f;
        var colorG = 1f;
        var colorB = 1f;
        var alpha = child.options.opacity / 255f;
        if (child.options.property != "")
        {
            colorR = prop.colorR / 255f;
            colorG = prop.colorG / 255f;
            colorB = prop.colorB / 255f;
            alpha = prop.opacity / 255f;
        }
        if (prop.isOutpic > 0)
		{
            material = null;
            alpha = 0;
		}
		imgComponent.color = new Color (colorR, colorG, colorB, alpha);
        imgComponent.sprite = sprite;
        imgComponent.material = material;

        if (prop.isOutpic > 0) { // 外部图片
			if(prop.isOutpic == 2) return imgComponent.gameObject;
			// 外部图片统一放到"out/*/*.png"  child_tvaabb  child_tvaabbBoy
			string outSrc = PSD2UI.curBaseAssetsDir + rootPath + "/" + imgPath;
			string outImg = PSDConst.OUT_PATH + "/" + rootPath+"-"+imgPath;
			string saveDir = Directory.GetParent(outImg).FullName;
			string outMetaSrc = outSrc + ".meta";
			string outMetaImg = outImg + ".meta";
			// prefab路径只能使用相对路径!!!
			if (!Directory.Exists (saveDir)) {
				Directory.CreateDirectory (saveDir);
			}
			if (!File.Exists (outImg)) {
				// 对原图先转换成精灵图片后拷贝
				//Sprchildanager.conversion(outSrc);
				File.Copy (outSrc,outImg);
				File.Copy (outMetaSrc,outMetaImg);
			}
			else
			{
				File.Delete(outImg);
				string metaTxt = outImg + ".meta";
				if(File.Exists (metaTxt))
				{
					File.Delete(metaTxt);
				}
				File.Copy (outSrc,outImg);
				File.Copy (outMetaSrc,outMetaImg);	
			}
			return imgComponent.gameObject;
		}
		// 是否设置九宫格
		if (child.options.isScaleImage == true) {
			// Texture图集九宫格切图
			TextureImporter importer = null;
			if (isCommon) {
				importer = AssetImporter.GetAtPath (PSDConst.UI_COMMON_PATH) as TextureImporter;
				importer.isReadable = true;
			} else {
				importer = AssetImporter.GetAtPath (PSDConst.GUI_PATH + file_result + '/' + file_result + ".png") as TextureImporter;
				importer.isReadable = true;
			}

			SpriteMetaData[] datas = importer.spritesheet;
			for (int i = 0; i < datas.Length; i++) {
				//Debug.Log (datas[i].name + "<<<>>>" + atlasName);
				if (datas[i].name == atlasName) {
					//Debug.Log ("9sclice");
					datas [i].border = new Vector4 (child.options.left, child.options.bottom, child.options.right, child.options.top);
				}
			}
			importer.spritesheet = datas;
			imgComponent.type = UnityEngine.UI.Image.Type.Sliced;
			importer.textureType = TextureImporterType.Sprite;
			importer.spriteImportMode = SpriteImportMode.Multiple;
			importer.mipmapEnabled = false;
			importer.SaveAndReimport();
		}

		return imgComponent.gameObject;
	}
}
