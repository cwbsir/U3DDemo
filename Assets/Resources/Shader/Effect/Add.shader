Shader "KYU3D/Effect/Add"
{
	Properties
	{
		_MainTex( "_MainTex", 2D ) = "gray" {}
		_Color( "_Color", Color ) = ( 1, 1, 1, 1 )
		_Intensity( "_Intensity", Range( 0.1, 4 )) = 2
		_ClipY("_ClipY",Float)=0
	}

	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
		}

		Pass
		{
			Lighting Off
			Fog {Mode Off}
			Cull Off
			ZTest LEqual
			ZWrite Off
			Blend SrcAlpha One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "../KyUnity.cginc"

			struct v2f
			{
				float4 pos : POSITION;
				half2 uv : TEXCOORD0;
				fixed4 color : TEXCOORD1;
				float3 worldPos:TEXCOORD2;
			};


			sampler2D _MainTex;
			half4 _MainTex_ST;
			fixed _Intensity;
			fixed4 _Color;
			float _ClipY;	
			
			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = TRANSFORM_TEX( v.texcoord, _MainTex );
				o.color = v.color * _Intensity * _Color;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}
			
			fixed4 frag( v2f i ) : COLOR
			{
				fixed4 c = tex2D( _MainTex, i.uv );
				c *= i.color;
				clip(i.worldPos.y - _ClipY);
				return c;
			}
			ENDCG
		}
	}

	Fallback "KYU3D/Simple/Transparent"
}
