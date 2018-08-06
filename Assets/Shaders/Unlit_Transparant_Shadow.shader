// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unlit shader that nonetheless receives shadows.
// Adapted from: http://answers.unity3d.com/questions/1187379
Shader "Custom/Unlit Transparent Shadow Receiver" {
     Properties {
         _Color ("Main Color", Color) = (1,1,1,1)
         _MainTex ("Base (RGB)", 2D) = "white" {}
     }
     SubShader {
         Tags {"Queue" = "Geometry" "IgnoreProjector"="True" "RenderType" = "Transparent"}
         //Cull Off
         ZWrite On
         Blend SrcAlpha OneMinusSrcAlpha
 
         Pass {
             Tags { "LightMode" = "ForwardBase" }    // handles main directional light, vertex/SH lights, and lightmaps
             CGPROGRAM
				 //#pragma surface surf Lambert noforwardadd
                 #pragma vertex vert
                 #pragma fragment frag
                 #pragma multi_compile_fwdbase
                 #pragma fragmentoption ARB_fog_exp2
                 #pragma fragmentoption ARB_precision_hint_fastest
                 
                 #include "UnityCG.cginc"
                 #include "AutoLight.cginc"
                 
                 struct v2f
                 {
                     float4    pos            : SV_POSITION;
                     float2    uv            : TEXCOORD0;
                     LIGHTING_COORDS(1,2)
                 };
 
                 float4 _MainTex_ST;
 
                 v2f vert (appdata_tan v)
                 {
                     v2f o;
                     
                     o.pos = UnityObjectToClipPos( v.vertex);
                     o.uv = TRANSFORM_TEX (v.texcoord, _MainTex).xy;
                     TRANSFER_VERTEX_TO_FRAGMENT(o);
                     return o;
                 }
 
                 sampler2D _MainTex;
 
                 fixed4 frag(v2f i) : COLOR
                 {
                     //fixed atten = LIGHT_ATTENUATION(i);    // Light attenuation + shadows.
                     fixed atten = SHADOW_ATTENUATION(i); // Shadows ONLY.
                     fixed4 tex = tex2D(_MainTex, i.uv);
                     fixed4 c = tex * atten;    // attenuate color
                     c.a = tex.a;                // don't attenuate alpha
                     return c;
                 }
             ENDCG
         }
          Pass {
             Tags {"LightMode" = "ForwardAdd"}    // handles per-pixel additive lights (called once per such light)
             Blend One One
             CGPROGRAM
                 #pragma vertex vert
                 #pragma fragment frag
                 #pragma multi_compile_fwdadd_fullshadows
                 #pragma fragmentoption ARB_fog_exp2
                 #pragma fragmentoption ARB_precision_hint_fastest
                 
                 #include "UnityCG.cginc"
                 #include "AutoLight.cginc"
                 
                 struct v2f
                 {
                     float4    pos            : SV_POSITION;
                     float2    uv            : TEXCOORD0;
                     LIGHTING_COORDS(1,2)
                 };
 
                 float4 _MainTex_ST;
 
                 v2f vert (appdata_tan v)
                 {
                     v2f o;
                     
                     o.pos = UnityObjectToClipPos( v.vertex);
                     o.uv = TRANSFORM_TEX (v.texcoord, _MainTex).xy;
                     TRANSFER_VERTEX_TO_FRAGMENT(o);
                     return o;
                 }
 
                 sampler2D _MainTex;
 
                 fixed4 frag(v2f i) : COLOR
                 {
                    // fixed atten = LIGHT_ATTENUATION(i);    // Light attenuation + shadows.
                     fixed atten = SHADOW_ATTENUATION(i); // Shadows ONLY.
                     fixed4 tex = tex2D(_MainTex, i.uv);
                     fixed4 c = tex * atten;    // attenuate color
                     c.a = tex.a;                // don't attenuate alpha
                     return c;
                 }
             ENDCG
         }
     }
     FallBack "VertexLit"
}