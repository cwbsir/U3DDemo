Shader "KYU3D/Scene/FarViewCut"
{
	Properties 
	{
		_MainTex ( "_MainTex", 2D ) = "gray" {}
		_CutOff ( "_CutOff", Range( 0, 1 ) ) = 0.7
	}

	SubShader 
	{
		LOD 200

		Tags
		{
			"Queue" = "AlphaTest"
			"IgnoreProjector" = "True"
		}

		Pass 
		{
			Lighting Off 
			Fog { Mode Off }
			Cull Off 
			ZTest LEqual
			ZWrite On 

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag 
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "../KyUnity.cginc"

			sampler2D _MainTex;
			fixed _CutOff;

			struct v2f 
			{
				float4 pos : SV_POSITION;
				half2 uv_MainTex : TEXCOORD0;
				half4 fog : TEXCOORD1;
			};

			v2f vert( appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv_MainTex = v.texcoord.xy;
				o.fog = FogColor( o.pos.w, v.vertex );
				return o;
			}

			fixed4 frag( v2f i ) : SV_Target 
			{
				fixed4 c = tex2D( _MainTex, i.uv_MainTex );
				clip( c.a - _CutOff );
				c.rgb = MixFog( c.rgb, i.fog );
				return c;
			}

			ENDCG
		}
	}

	FallBack "KYU3D/Simple/Cut"
}
