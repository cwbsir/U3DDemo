using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;

public class RectComponent {

	// 初始化
	public static GameObject InitRectComponent(Children child,GameObject parentObj) {
		// 获取属性
		var propStr = child.options.property;
		var props = propStr.Split('\r');
		var prop = new Property ();
		prop.DeserializeProperty (props);

		// 构建控件
		string path = PSDConst.GetPrefabPathByName("GameObject");
		GameObject temp = AssetDatabase.LoadAssetAtPath(path,typeof(GameObject)) as GameObject;
		GameObject childObject = GameObject.Instantiate(temp) as GameObject;
		childObject.name = child.name;
		childObject.transform.SetParent(parentObj.transform);

 		RectTransform rect = childObject.GetComponent<RectTransform>();


		RectTransform parentRect = parentObj.GetComponent<RectTransform>();

		// 设置锚点
		// Vector2 anchorP = new Vector2 (prop.anchors[0], prop.anchors[1]);
		Vector2 anchorP = prop.anchors;
		rect.anchorMin = PSDConst.PIVOTPOINT1;
		rect.anchorMax = PSDConst.PIVOTPOINT1;
		rect.pivot = anchorP; 

		// RectTransform 根据锚点计算 x,y位置
		if (anchorP == PSDConst.PIVOTPOINT0)
		{ // 中间
			float x = child.options.x + (child.options.width / 2);
			float y = child.options.y + (child.options.height / 2);
			rect.localPosition = new Vector3 (x, -y);

			rect.sizeDelta = new Vector2 (child.options.width, child.options.height);
		}
		else//默认左上
		// else if (anchorP == PSDConst.PIVOTPOINT1) 
		{ // 左上
			float x = child.options.x;
			float y = child.options.y;
			rect.localPosition = new Vector3(x,-y);
			
			rect.sizeDelta = new Vector2 (child.options.width,child.options.height);
		} 

		return childObject;
	}
}
