Shader "MyShader/EffectClip"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_ClipRect ("clip Rect", Vector) = (0, 0, 0, 0)
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent"}

		Pass
		{
			Tags { "LightMode" = "ForwardBase"}
			Blend SrcAlpha One
			Cull Off 
			ZWrite Off 
			Lighting Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#pragma multi_compile __ UI_CLIP

			//移除变体，有一部分unity会自动移除
			#pragma skip_variants SHADOWS_SCREEN VERTEXLIGHT_ON

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color :Color;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float2 worldVertex : TEXCOORD1;
				float4 vertexColor: TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _ClipRect;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.vertexColor = v.color;
				
#ifdef UI_CLIP
				o.worldVertex = mul(unity_ObjectToWorld, v.vertex);
#endif
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv) * i.vertexColor;
#ifdef UI_CLIP
				col.a *= UnityGet2DClipping(i.worldVertex.xy, _ClipRect);
				clip(col.a - 0.001);
#endif
				return col;
			}
			ENDCG
		}
	}
}
