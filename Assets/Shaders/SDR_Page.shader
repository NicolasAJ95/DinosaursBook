// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Page"
{
	Properties
	{
		_FrontTint("Front Tint", Color) = (1,1,1,1)
		_Front("Front", 2D) = "white" {}
		_BackTint("Back Tint", Color) = (1,1,1,1)
		_Back("Back", 2D) = "white" {}
		_BumpMap("BumpMap", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
		};

		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _Front;
		uniform float4 _Front_ST;
		uniform float4 _FrontTint;
		uniform sampler2D _Back;
		uniform float4 _Back_ST;
		uniform float4 _BackTint;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 tex2DNode5 = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			float3 appendResult8 = (float3(tex2DNode5.xy , ( tex2DNode5.b * i.ASEVFace )));
			o.Normal = appendResult8;
			float2 uv_Front = i.uv_texcoord * _Front_ST.xy + _Front_ST.zw;
			float2 uv_Back = i.uv_texcoord * _Back_ST.xy + _Back_ST.zw;
			float4 switchResult1 = (((i.ASEVFace>0)?(( tex2D( _Front, uv_Front ) * _FrontTint )):(( tex2D( _Back, uv_Back ) * _BackTint ))));
			o.Albedo = switchResult1.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
2070;38;2017;1036;1529.067;1021.49;1.3;True;True
Node;AmplifyShaderEditor.SamplerNode;3;-698.5828,-508.7722;Float;True;Property;_Back;Back;3;0;Create;True;0;0;False;0;None;732d2e68a5fcbd342a515bd1dd7b189f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-677.0096,-23.83027;Float;True;Property;_BumpMap;BumpMap;4;0;Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FaceVariableNode;6;-81.4465,121.0172;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-524.6312,-701.7177;Float;False;Property;_FrontTint;Front Tint;0;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-980.8717,-777.6674;Float;True;Property;_Front;Front;1;0;Create;True;0;0;False;0;None;233e5b8e2bb94781839ee6c48d6a249b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-688.621,-234.3367;Float;False;Property;_BackTint;Back Tint;2;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-231.621,-349.3367;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-264.4057,-757.6541;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;87.55348,44.01721;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;25.41217,-195.6671;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;1;-67.59958,-558.504;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;235.7425,-373.9611;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/Page;False;False;False;False;False;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;False;False;False;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;3;0
WireConnection;11;1;12;0
WireConnection;9;0;2;0
WireConnection;9;1;10;0
WireConnection;7;0;5;3
WireConnection;7;1;6;0
WireConnection;8;0;5;0
WireConnection;8;2;7;0
WireConnection;1;0;9;0
WireConnection;1;1;11;0
WireConnection;0;0;1;0
WireConnection;0;1;8;0
ASEEND*/
//CHKSM=68BBAED35C7C4D3AFDFCC6147B5A221381019E7C