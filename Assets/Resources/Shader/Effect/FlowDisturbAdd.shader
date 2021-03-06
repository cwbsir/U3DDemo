﻿
Shader "KYU3D/Effect/FlowDisturbAdd" 
{
	Properties
	{
		_MainTex( "_MainTex", 2D ) = "gray" {}
		_FlowSpeedU( "_FlowSpeedU", Float ) = 0
		_FlowSpeedV( "_FlowSpeedV", Float ) = 0.2
		_Color( "_Color", Color ) = ( 1.0, 0.8, 0, 1 )
		_EmissiveIntensity( "_EmissiveIntensity", Float ) = 1
		_MainDisturb( "_MainDisturb", Float ) = 0.03
		_Disturb( "_Disturb", 2D ) = "gray" {}
		_DisturbScale( "_DisturbScale", Float ) = 4
		_DisturbSpeedU( "_DisturbSpeedU", Float ) = 0.5
		_DisturbSpeedV( "_DisturbSpeedV", Float ) = 0		
		_ClipY("_ClipY",Float)=0
	}

	SubShader
	{
		LOD 300

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
		}

		Pass
		{
			Lighting Off 
			Fog { Mode Off }
			Cull Off 
			ZTest LEqual
			ZWrite Off 
			Blend SrcAlpha One

			CGPROGRAM 

			#pragma vertex vert
			#pragma fragment frag 
			#pragma fragmentoption ARB_precision_hint_fastest
			#include"../KyUnity.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv_MainTex : TEXCOORD0;
				fixed4 color : TEXCOORD1;
				float3 worldPos:TEXCOORD3;
				float2 uv_Disturb : TEXCOORD2;
			};

			sampler2D _MainTex;
			half4 _MainTex_ST;
			float _FlowSpeedU;
			float _FlowSpeedV;
			fixed4 _Color;
			half _EmissiveIntensity;
			half _MainDisturb;
			sampler2D _Disturb;
			float _DisturbSpeedU;
			float _DisturbSpeedV;
			float _DisturbScale;		
			float _ClipY;		

			v2f vert( appdata_full v )
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv_MainTex = TRANSFORM_TEX( v.texcoord.xy, _MainTex );
				o.uv_MainTex += float2( _FlowSpeedU, _FlowSpeedV ) * _Time.y;
				o.color = v.color * _Color * _EmissiveIntensity;
				o.uv_Disturb = v.texcoord1.xy * _DisturbScale - float2( _DisturbSpeedU, _DisturbSpeedV ) * _Time.y;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}

			fixed4 frag( v2f i ) : SV_Target
			{
				fixed disturb = tex2D( _Disturb, i.uv_Disturb ).g;
				fixed4 c = tex2D( _MainTex, i.uv_MainTex + (disturb - 0.5) * _MainDisturb );
				c *= i.color;
				clip(i.worldPos.y - _ClipY);
				return c;
			}

			ENDCG 
		}
	}
	
	FallBack "KYU3D/Effect/DisturbAdd"
}
