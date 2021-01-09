// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "KYU3D/Scene/PlantCut"
{
	Properties
	{
		_MainTex( "_MainTex", 2D ) = "gray" {}
		_Cutoff( "_Cutoff", Range( 0, 1 ) ) = 0.5
		_LightmapIntensity( "_LightmapIntensity", float ) = 1
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
			Fog {Mode Off}
			Cull Off
			ZTest LEqual
			ZWrite On

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "../KyUnity.cginc"

			struct v2f
			{
				float4 pos : POSITION;
				half2 uv : TEXCOORD0;
				half2 lmuv : TEXCOORD1;
				half4 fog : TEXCOORD2;
			};

			sampler2D _MainTex;
			fixed _Cutoff;
			half _LightmapIntensity;

			v2f vert( appdata_full v )
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = v.texcoord.xy;
				o.lmuv = LightMapUV( v.texcoord1 );
				o.fog = FogColor( o.pos.w, v.vertex );
				return o;
			}

			fixed4 frag( v2f i ) : COLOR
			{
				fixed4 c = tex2D( _MainTex, i.uv );
				clip( c.a - _Cutoff );
				fixed3 lm = LightMapColor( i.lmuv ) * _LightmapIntensity;
				c.rgb *= lm;
				c.rgb = MixFog( c.rgb, i.fog );
				return c;
			}

			ENDCG
		}
	}
	
	Fallback "KYU3D/Simple/Cut"
}
