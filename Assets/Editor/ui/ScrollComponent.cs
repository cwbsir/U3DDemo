using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;

public class ScrollComponent {
	public static GameObject InitComponent(Children child,GameObject parentObj) {
		// 获取属性
		var propStr = child.options.property;
		var props = propStr.Split('\r');
		var prop = new Property ();
		prop.DeserializeProperty (props);

		/** ScrollView的组成

		ScrollRect 滚动范围
			--Viewport 可视范围
			--Scrollbar 垂直水平滚动条(可有可无)
		*/
		// 控件相关获取
		string path = PSDConst.GetPrefabPathByName("ScrollView");
		GameObject temp = AssetDatabase.LoadAssetAtPath(path,typeof(GameObject)) as GameObject;
		GameObject childObject = GameObject.Instantiate(temp) as GameObject;
		childObject.name = child.name;
		childObject.transform.SetParent(parentObj.transform,false);
		RectTransform rectTransform = childObject.GetComponent<RectTransform>();

		RectTransform parentRect = parentObj.GetComponent<RectTransform>();

//		 如果有额外属性，先根据额外属性设置控件
		if ((prop.scaleX > 0f) || (prop.scaleY > 0f)) {
			rectTransform.localScale = new Vector3 (prop.scaleX,prop.scaleY);
		}

		// 设置锚点
		// Vector2 anchorP = new Vector2 (prop.anchors[0], prop.anchors[1]);
		Vector2 anchorP = prop.anchors;
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
			RectTransform maskTrans = rectTransform.Find ("Viewport") as RectTransform;
			maskTrans.sizeDelta = new Vector2 (child.options.width,child.options.height);
		}
		else//默认左上
		// else if (anchorP == PSDConst.PIVOTPOINT1) 
		{ // 左上
			float x = child.options.x;
			float y = child.options.y;
			rectTransform.localPosition = new Vector3(x,-y);

			rectTransform.sizeDelta = new Vector2 (child.options.width,child.options.height);
			RectTransform maskTrans = rectTransform.Find ("Viewport") as RectTransform;
			maskTrans.sizeDelta = new Vector2 (child.options.width,child.options.height);
		}


		return childObject;
	}
}
