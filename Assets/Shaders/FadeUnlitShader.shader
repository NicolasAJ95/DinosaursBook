Shader "Custom/FadeUnlitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_FadeSpread("Fade Spread", Range(1, 15)) = 10
		_FadePosX("Fade Position X", Range(-1, 1)) = 0
		_FadePosY("Fade Position Y", Range(-1, 1)) = 0
		[MaterialToggle] _IsRight("Is Right", Float) = 0
		[MaterialToggle] _IsUp("Is Up", Float) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _FadeSpread;
			float _FadePosX;
			float _FadePosY;
			float _IsRight;
			float _IsUp;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				
				// apply fade on x axis
				float uvx = _IsRight + (-2 * _IsRight + 1) * i.uv.x;
				float distanceX = (uvx - _FadePosX)*_FadeSpread;
				float clampedDistanceX = clamp(distanceX, 0, 1);
				
				// apply fade on y axis
				float uvy = _IsUp + (-2 * _IsUp + 1) * i.uv.y;
				float distanceY = (uvy - _FadePosY)*_FadeSpread;
				float clampedDistanceY = clamp(distanceY, 0, 1);

				col.w = clampedDistanceX * clampedDistanceY;

				return col;
			}
			ENDCG
		}
	}
}
