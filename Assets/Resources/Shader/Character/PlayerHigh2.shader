
Shader "KYU3D/Character/PlayerHigh2"
{
	Properties
	{
		[NoScaleOffset]_MainTex( "_MainTex", 2D ) = "gray" {}
		[NoScaleOffset]_Normal( "_Normal", 2D ) = "bump" {}
		[NoScaleOffset]_Mask1( "Shininess(R)Specular(G)Skin(B)", 2D ) = "gray" {}
		[NoScaleOffset]_Mask2( "Reflect(R)", 2D ) = "gray" {}
		[Space( 20 )]
		_FillColor( "_FillColor", Color ) = ( 0.6, 0.7, 0.8, 1 )
		_DiffuseWeaken( "_DiffuseWeaken", Range( 0, 1 ) ) = 0.4
		[Space( 20 )]
		_RimColor( "_RimColor", Color ) = ( 0.6, 0.8, 0.9, 1 )
		_RimIntensity( "_RimIntensity", float ) = 1.5
		_RimRight( "_RimRight", Range( -1, 1 ) ) = 0.65
		_RimUp( "_RimUp", Range( -1, 1 ) ) = 0.45
		[Space( 20 )]
		_Shininess( "_Shininess", float ) = 10
		_SpecularColorRatio( "_SpecularColorRatio", Range( 0, 1 ) ) = 0
		_SpecularColor( "_SpecularColor", Color ) = ( 1.0, 0.5, 0.0, 1 )
		[Space( 20 )]
		_SkinSoft( "_SkinSoft", float ) = 0.5
		[Space( 20 )]
		[NoScaleOffset]_Reflect( "_Reflect", CUBE ) = "" {}
		_ReflectIntensity( "_ReflectIntensity", float ) = 0.5
		_ReflectPow( "_ReflectPow", float ) = 2
		_NormalEnhance( "_NormalEnhance", Range( -2, 2 ) ) = 0
		_Inverse( "_Inverse", vector ) = ( 1, 1, 1, 0 )
		[Space( 20 )]
		_ShadowLightX( "_ShadowLightX", Range( -1, 1 ) ) = -1
		_ShadowLightY( "_ShadowLightY", Range( -1, 1 ) ) = -1
		_ShadowLightZ( "_ShadowLightZ", Range( -1, 1 ) ) = -1
		_ShadowPlatY( "_ShadowPlatY", float ) = 0
		_ShadowFallOff("_ShadowFallOff",float) = 0
		_ShadowColor("_ShadowColor",Color) = (0,0,0,1)

		_GrayAmount( "_GrayAmount", Range( 0, 1 ) ) = 0

		_Outline("Thick of Outline",range(0,50)) = 0.03
		_OutLineStrength("_OutLineStrength",Range(0,1)) = 0.6
		_OutColor("OutColor",color) = (0,0,0,0)
	}

	SubShader
	{
		LOD 500

		Tags
		{
			"Queue" = "Geometry"
			"IgnoreProjector" = "True"
		}

		CGINCLUDE
			#include "../KyUnity.cginc"

			struct v2f
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 tangent : TEXCOORD2;
				float3 bitangent : TEXCOORD3;
				float3 view : TEXCOORD4;
				float3 rim : TEXCOORD5;
				half4 color:COLOR;
			};
			
			sampler2D _MainTex;
			sampler2D _Mask1;
			sampler2D _Mask2;
			float3 _FillColor;
			float _DiffuseWeaken;
			float _SpecularColorRatio;
			float _SkinSoft;
			float3 _RimColor;
			float _RimIntensity;
			float _RimRight;
			float _RimUp;
			float3 _SpecularColor;
			samplerCUBE _Reflect;
			float _ReflectIntensity;
			float _ReflectPow;
			sampler2D _Normal;
			float _NormalEnhance;
			float2 _Inverse;
			half _GrayAmount;
			float _OutLineStrength;
			float _Shininess;

			inline half4 getFragCol(v2f i)
			{
				float4 c;
				float4 mainCol = tex2D( _MainTex, i.uv );
				float4 m1 = tex2D( _Mask1, i.uv );
				float4 m2 = tex2D( _Mask2, i.uv );
				float4 nm = tex2D( _Normal, i.uv );
				float3 n = nm.xyz * 2 - 1;
				n.xy *= _NormalEnhance;
				// n.z -= _NormalEnhance;
				n = normalize( mul( n, float3x3( i.tangent, i.bitangent, i.normal ) ) );
				float3 v = normalize( i.view );
				float vn = dot( v, n );
				float r = 1 - max( vn, 0 );
				float nr = max( 0, dot( n, i.rim ) );
				float4 e = texCUBE( _Reflect, vn * n * 2 - v );
				float3 sc = ( ( _SpecularColor - mainCol.rgb ) * _SpecularColorRatio + mainCol.rgb );
				float rl =  _ReflectIntensity * pow( r, _ReflectPow ) * m2.r;
				float3 rc = _RimColor * _RimIntensity;
				float3 ro = 2 * ( mainCol.rgb + rc - rc * mainCol.rgb - 0.5 );
				
				c.rgb = ( _LightColor0.rgb - _FillColor ) * saturate( dot( n, _WorldSpaceLightPos0.xyz ) + 0.1 ) + _FillColor;
				c.rgb += m1.b > 0.8 ? _SkinSoft - _SkinSoft * c.rgb : 0;
				c.rgb *= mainCol.rgb - sc * m1.g * _DiffuseWeaken;
				c.rgb += ( ro - c.rgb ) * nr;
				c.rgb += e.rgb * rl;
				c.rgb = lerp( c.rgb, GrayScale( c.rgb ), _GrayAmount );
				c.a = mainCol.a;
				return c;
			}
		ENDCG

		// Pass
		// {
		// 	Cull Front
		// 	ZWrite On

		// 	CGPROGRAM
		// 	#pragma multi_compile_fog
		// 	#pragma vertex vert
		// 	#pragma fragment frag
		// 	#include "UnityCG.cginc"

		// 	// struct v2f 
		// 	// {
		// 	// 	float4 pos:SV_POSITION;
		// 	// };

		// 	float _Outline;
		// 	float _Factor;
		// 	fixed4 _OutColor;
		// 	float _ZSmooth;

		// 	v2f vert(appdata_full v) 
		// 	{
		// 		v2f o;
		// 		float3 normal = v.normal;
		// 		float4 pos = float4(UnityObjectToViewPos(v.vertex + float4(normal, 0) * _Outline * 0.01), 1.0);
		// 		o.pos = mul(UNITY_MATRIX_P, pos);

		// 		o.uv = v.texcoord.xy;
		// 		o.normal = mul( v.normal, (float3x3)unity_WorldToObject );
		// 		o.tangent = mul( (float3x3)unity_ObjectToWorld, v.tangent.xyz );
		// 		o.bitangent = cross( o.normal, o.tangent ) * v.tangent.w * _Inverse.y;
		// 		o.tangent *= _Inverse.x;
		// 		o.view = _WorldSpaceCameraPos - mul( unity_ObjectToWorld, v.vertex ).xyz;
		// 		o.rim = mul( normalize( float3( _RimRight, _RimUp, -1 ) ), (float3x3)UNITY_MATRIX_V );
		// 		return o;
		// 	}
			
		// 	float4 frag(v2f i) :COLOR
		// 	{
		// 		float4 c = getFragCol(i);
		// 		c.rgb *= _OutLineStrength;
		// 		return c;
		// 	}
		// 	ENDCG
		// }

		Pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
			}
			Fog {Mode Off}

			CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile_fwdbase
			#pragma vertex vert
			#pragma fragment frag

			v2f vert( appdata_full v )
			{
				v2f o;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = v.texcoord.xy;
				o.normal = UnityObjectToWorldNormal( v.normal );
				o.tangent = mul( (float3x3)unity_ObjectToWorld, v.tangent.xyz );
				o.bitangent = cross( o.normal, o.tangent ) * v.tangent.w * _Inverse.y;
				o.tangent *= _Inverse.x;
				o.view = _WorldSpaceCameraPos - mul( unity_ObjectToWorld, v.vertex ).xyz;
				o.rim = mul( normalize( float3( _RimRight, _RimUp, -1 ) ), (float3x3)UNITY_MATRIX_V );
				return o;
			}

			float4 frag( v2f i ) : COLOR
			{
				float4 c = getFragCol(i);
				return c;
			}

			ENDCG
		}

		Pass
		{
			Tags
			{
				"LightMode" = "ForwardAdd"
			}
			Fog {Mode Off}
			ZTest LEqual
			ZWrite Off
			Blend One One

			CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile_fwdadd
			#pragma vertex vert
			#pragma fragment frag
			#include "../KyUnity.cginc"

			struct v2f_add
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 tangent : TEXCOORD2;
				float3 bitangent : TEXCOORD3;
			#ifndef USING_DIRECTIONAL_LIGHT
				float3 view : TEXCOORD4;
				float3 light : TEXCOORD5;
			#endif
			};
			
			// sampler2D _MainTex;
			// sampler2D _Mask1;
			// sampler2D _Mask2;
			// float3 _FillColor;
			// float _DiffuseWeaken;
			// float _Shininess;
			// float3 _SpecularColor;
			// float _SpecularColorRatio;
			// float _SkinSoft;
			// sampler2D _Normal;
			// float _NormalEnhance;
			// float2 _Inverse;
			// half _GrayAmount;

			v2f_add vert( appdata_full v )
			{
				v2f_add o;
				float3 wp = mul( unity_ObjectToWorld, v.vertex ).xyz;
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = v.texcoord.xy;
				// o.normal = mul( v.normal, (float3x3)unity_WorldToObject );
				o.normal = UnityObjectToWorldNormal( v.normal );
				o.tangent = mul( (float3x3)unity_ObjectToWorld, v.tangent.xyz );
				o.bitangent = cross( o.normal, o.tangent ) * v.tangent.w * _Inverse.y;
				o.tangent *= _Inverse.x;
			#ifndef USING_DIRECTIONAL_LIGHT
				o.view = _WorldSpaceCameraPos - wp;
				o.light = _WorldSpaceLightPos0.xyz - wp;
			#endif
				return o;
			}

			float4 frag( v2f_add i ) : COLOR
			{
				float4 c;
				float4 t = tex2D( _MainTex, i.uv );
				float4 m1 = tex2D( _Mask1, i.uv );
				float4 m2 = tex2D( _Mask2, i.uv );
				float4 nm = tex2D( _Normal, i.uv );
				float3 n = nm.xyz * 2 - 1;
				n.xy *= _NormalEnhance;
				// n.z -= _NormalEnhance;
				n = normalize( mul( n, float3x3( i.tangent, i.bitangent, i.normal ) ) );
			#ifndef USING_DIRECTIONAL_LIGHT
				float3 v = normalize( i.view );
				float3 f = dot( v, n ) * n * 2 - v;
				float3 l = normalize( i.light );
				float s = 2 * pow( max( dot( l, f ), 0 ), m1.r * _Shininess + 0.5 ) * m1.g / ( 0.5 + dot( i.light, i.light ) );
				c.rgb = _LightColor0.rgb * ( _SpecularColorRatio * ( _SpecularColor - t.rgb ) + t.rgb ) * s;
			#else
				c.rgb = _LightColor0.rgb * max( dot( n, _WorldSpaceLightPos0.xyz ), 0 );
				c.rgb += m1.b > 0.8 ? - _SkinSoft * c.rgb : 0;
				c.rgb *= t.rgb - _DiffuseWeaken * ( _SpecularColorRatio * ( _SpecularColor - t.rgb ) + t.rgb ) * m1.g;
			#endif
				c.rgb = lerp( c.rgb, GrayScale( c.rgb ), _GrayAmount );
				c.a = t.a;
				return c;
			}

			ENDCG
		}

		Pass
		{
			Lighting Off
			Cull Back
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			//深度稍微偏移防止阴影与地面穿插
			Offset -1 , 0

			Stencil
			{
				Ref 0			
				Comp Equal			
				WriteMask 255		
				ReadMask 255
				Pass Invert
				Fail Keep
				ZFail Keep
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "../KyUnity.cginc"


			half _ShadowFallOff;
			half4 _ShadowColor;
			fixed _ShadowLightX;
			fixed _ShadowLightY;
			fixed _ShadowLightZ;
			half _ShadowPlatY;


			v2f vert(appdata_base v)
			{
				v2f o;
				float4 worldPos = mul(unity_ObjectToWorld,v.vertex);
				float3 shadowPos;
				fixed3 light = normalize(half3(_ShadowLightX,_ShadowLightY,_ShadowLightZ));
				shadowPos.xz = worldPos.xz - light.xz * max(0,worldPos.y - _ShadowPlatY)/light.y;
				shadowPos.y = min(worldPos.y,_ShadowPlatY);
				o.pos = UnityWorldToClipPos(shadowPos);
				
				float3 center = float3(unity_ObjectToWorld[0].w,_ShadowPlatY,unity_ObjectToWorld[2].w);
				o.color = _ShadowColor;
				o.color.a = 1 - saturate(distance(center,shadowPos) * _ShadowFallOff);

				return o;
			}

			fixed4 frag(v2f i):COLOR
			{
				return i.color;
			}
			ENDCG
		}
	}
	
	Fallback "KYU3D/Character/PlayerHigh"
}
