
Shader "KYU3D/Scene/Collection"
{
	Properties
	{
		_LightX( "_LightX", Range( -1, 1 ) ) = 1
		_LightY( "_LightY", Range( -1, 1 ) ) = 1
		_LightZ( "_LightZ", Range( -1, 1 ) ) = 1

		_MainTex( "_MainTex", 2D ) = "gray" {}
		_AmbientIntensity( "_AmbientIntensity", float ) = 1
		_DiffuseIntensity( "_DiffuseIntensity", float ) = 1

		_SpecularTex( "_SpecularTex(R)", 2D ) = "white" {}
		_Specular( "_Specular", Color ) = ( 1, 0.8, 0.5, 1 )
		_SpecularIntensity( "_SpecularIntensity", float ) = 1
		_Shininess( "_Shininess", float ) = 16
		
		_EdgeColor( "_EdgeColor", Color ) = ( 0.9, 0.9, 0.9, 1 )
		_EdgePow( "_EdgePow", float ) = 8
		_EdgeIntensity( "_EdgeIntensity", float ) = 1
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
				half3 normal : TEXCOORD1;
				half4 light : TEXCOORD2;
				half3 view : TEXCOORD3;
				half4 fog : TEXCOORD4;
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
			half3 _EdgeColor;
			half _EdgePow;
			half _EdgeIntensity;

			v2f vert( appdata_full v )
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = v.texcoord.xy;
				half3 l = normalize( half3( _LightX, _LightY, _LightZ ) );
				half4 wp = mul( unity_ObjectToWorld, v.vertex );
				o.view = normalize( _WorldSpaceCameraPos - wp.xyz );
				o.normal = mul( v.normal, (half3x3)unity_WorldToObject );
				o.light.xyz = normalize( o.view + l );
				o.light.w = max( dot( l, o.normal ), 0 ) * _DiffuseIntensity;
				o.fog = FogColor( o.pos.w, v.vertex );
				return o;
			}

			fixed4 frag( v2f i ) : COLOR
			{
				fixed4 c;
				half4 tex = tex2D( _MainTex, i.uv );
				half4 st = tex2D( _SpecularTex, i.uv );
				half s = pow( max( 0, dot( i.normal, normalize( i.light.xyz ) ) ), _Shininess ) * _SpecularIntensity * st.r;
				half e = pow( max( 0, 1 - dot( i.view, i.normal ) ), _EdgePow );
				c.rgb = tex.rgb * ( _Ambient * _AmbientIntensity + _ObjDiffuse * i.light.w ) + _ObjSpecular * _Specular * s;
				c.rgb += ( _EdgeColor - c.rgb * 0.5 ) * _EdgeIntensity * e;
				c.rgb = MixFog( c.rgb, i.fog );
				c.a = tex.a;
				return c;
			}

			ENDCG
		}
	}
	
	Fallback "KYU3D/Scene/DynamicObj"
}
