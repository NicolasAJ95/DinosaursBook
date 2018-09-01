// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Toon" 
{
    Properties 
    {
		[MaterialToggle(_TEX_ON)] _DetailTex ("Enable Detail texture", Float) = 0 	//1
		_MainTex ("Detail", 2D) = "white" {}        								//2
		_ToonShade ("Shade", 2D) = "white" {}  										//3
		[MaterialToggle(_COLOR_ON)] _TintColor ("Enable Color Tint", Float) = 0 	//4
		_Color ("Base Color", Color) = (1,1,1,1)									//5	
		[MaterialToggle(_VCOLOR_ON)] _VertexColor ("Enable Vertex Color", Float) = 0//6        
		_Brightness ("Brightness 1 = neutral", Float) = 1.0				
 _Transparency("Transparency", Range(0.0,1)) = 1
    }
   
    Subshader
    {
    	Tags { "RenderType" = "Transparent"  "Queue" = "Transparent" }
		LOD 100
    	ZWrite On
	   	Cull Off
		
		Blend SrcAlpha OneMinusSrcAlpha
		Lighting Off
		Fog { Mode Off }

        Pass 
        {
            Name "BASE"
			
            CGPROGRAM
							
                #pragma vertex vert
                #pragma fragment frag

                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
                #pragma glsl_no_auto_normalization
                #pragma multi_compile _TEX_OFF _TEX_ON
                #pragma multi_compile _COLOR_OFF _COLOR_ON

                #if _TEX_ON
                sampler2D _MainTex;
				half4 _MainTex_ST;
				#endif
				
                struct appdata_base0 
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;

				};
				
                 struct v2f 
                 {
                    float4 pos : SV_POSITION;
                    #if _TEX_ON
                    half2 uv : TEXCOORD0;
                    #endif
                    half2 uvn : TEXCOORD1;

                 };
				 float _Transparency;
			
                v2f vert (appdata_full  v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos ( v.vertex );
                    float3 n = mul((float3x3)UNITY_MATRIX_IT_MV, normalize(v.normal));
					normalize(n);
                    n = n * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
                    o.uvn = n.xy;

                     #if _TEX_ON
					
                    o.uv = TRANSFORM_TEX ( v.texcoord, _MainTex );
                    #endif
                    return o;
                }

              	sampler2D _ToonShade;
                fixed _Brightness;
                
                #if _COLOR_ON

                #endif
                fixed4 _Color;	
                fixed4 frag (v2f i) : COLOR : SV_Target
                {
					/*fixed4 col = tex2D(_ToonShade, i.uvn) + _Color;
					col.a = _Transparency;
					return col;
					*/
					#if _COLOR_ON
					fixed4 toonShade = tex2D( _ToonShade, i.uvn )*_Color;

					#else
					fixed4 toonShade = tex2D( _ToonShade, i.uvn );
					#endif
					toonShade.a=_Transparency;
					#if _TEX_ON
					fixed4 detail = tex2D ( _MainTex, i.uv );
					return  toonShade * detail*_Brightness;
					#else
					return  toonShade * _Brightness;
					#endif
                }

            ENDCG
        }
    }
    Fallback "Legacy Shaders/Diffuse"
}