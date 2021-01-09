
Shader "KYU3D/Scene/DynamicObj"
{
	Properties
	{
		_LightX( "_LightX", Range( -1, 1 ) ) = 0
		_LightY( "_LightY", Range( -1, 1 ) ) = 1
		_LightZ( "_LightZ", Range( -1, 1 ) ) = 0

		_MainTex( "_MainTex", 2D ) = "gray" {}
		_AmbientIntensity( "_AmbientIntensity", float ) = 1
		_DiffuseIntensity( "_DiffuseIntensity", float ) = 1

		_SpecularTex( "_SpecularTex(R)", 2D ) = "white" {}
		_Specular( "_Specular", Color ) = ( 0.9, 0.9, 0.9, 1 )
		_SpecularIntensity( "_SpecularIntensity", float ) = 2.5
		_Shininess( "_Shininess", float ) = 30
	}

	SubShader
	{
		LOD 300

		Tags
		{
			"Queue" = "Geometry-40"
			"IgnoreProjector" = "True"
		}

		Pass
		{
			Lighting Off
			Fog {Mode Off}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "../KyUnity.cginc"

			struct v2f
			{
				float4 pos : POSITION;
				half2 uv : TEXCOORD0;
				half2 light : TEXCOORD1;
				half4 fog : TEXCOORD2;
			};
			
			half _LightX;
			half _LightY;
			half _LightZ;
			sampler2D _MainTex;
			half _AmbientIntensity;
			half _DiffuseIntensity;
			sampler2D _SpecularTex;
			half3 _Specular;
			half _SpecularIntensity;
			half _Shininess;

			v2f vert( appdata_full v )
			{
				v2f o;
				half3 l = normalize( half3( _LightX, _LightY, _LightZ ) );
				half3 n = mul( v.normal, (half3x3)unity_WorldToObject );
				half4 wp = mul( unity_ObjectToWorld, v.vertex );
				half3 e = normalize( _WorldSpaceCameraPos - wp.xyz );
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = v.texcoord.xy;
				o.light.x = max( dot( l, n ), 0 ) * _DiffuseIntensity;
				o.light.y = pow( max( dot( normalize( e + l ), n ), 0 ), _Shininess ) * _SpecularIntensity;
				o.fog = FogColor( o.pos.w, v.vertex );
				return o;
			}

			fixed4 frag( v2f i ) : COLOR
			{
				half4 tex = tex2D( _MainTex, i.uv );
				half4 st = tex2D( _SpecularTex, i.uv );
				fixed4 c;
				c.rgb = tex.rgb * ( _Ambient * _AmbientIntensity + _ObjDiffuse * i.light.x + _ObjSpecular * _Specular * st.r * i.light.y );
				c.rgb = MixFog( c.rgb, i.fog );
				c.a = tex.a;
				return c;
			}

			ENDCG
		}
	}
	
	Fallback "KYU3D/Simple/Texture"
}
