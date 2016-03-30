Shader "CookbookShaders/BasicDiffuse" {
	// 对应纹理GUI元素的属性
	Properties {
		_Color ("Color", Color) = (1,1,1,1)

		// For Test
		_RampTex ("Albedo (RGB)", 2D) = "white" {}
		//自发光
		_EmissiveColor("Emissive Color", Color) = (1,1,1,1)
		//环境光
		_AmbientColor("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue("This is a Slider", Range(0, 10)) = 2.5

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0


		// 纹理滚动
		_MainTint("Diffuse Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ScrollXSpeed("X Scroll Speed", Range(0, 10)) = 2
		_ScrollYSpeed("Y Scroll Speed", Range(0, 10)) = 2

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows
		//#pragma surface指令告诉着色器使用哪个光照模型计算
		#pragma surface surf Lambert
		//#pragma surface surf BasicDiffuse

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		//sampler2D _MainTex;
		sampler2D _RampTex;
		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;

		fixed4 _MainTint;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) {
			//// Albedo comes from a texture tinted by color
			////fixed4 c = tex2D (_MainTex, IN.uv_MainTex);// * _Color;
			//float4 c;
			//c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);
			//o.Albedo = c.rgb;
			//// Metallic and smoothness come from slider variables
			////o.Metallic = _Metallic;
			////o.Smoothness = _Glossiness;
			//o.Alpha = c.a;

			//Create a sperate variable to store our uvs
			//before we pass them to the tex2D() function
			fixed2 scrolledUV = IN.uv_MainTex;

			//Create variables that store the individual x and y
			//components for the uvs scaled by time
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;

			//Apply the final uv offset
			scrolledUV += fixed2(xScrollValue, yScrollValue);

			//Apply textures and tint
			half4 c = tex2D(_MainTex, scrolledUV);
			o.Albedo = c.rgb * _MainTint,
			o.Alpha = c.a;
		}

		// 自定义光照模型(函数)——LightingName
		//inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		//{
		//	//float difLight = max(0, dot(s.Normal, lightDir));
		//	float difLight = dot(s.Normal, lightDir);
		//	//观察方向与表面法向量进行点积运算
		//	float rimLight = dot(s.Normal, viewDir);
		//	// Half Lambert
		//	float hLambert = difLight * 0.5 + 0.5;
		//	// 传UV坐标
		//	float3 ramp = tex2D(_RampTex, float2(hLambert, rimLight)).rgb;

		//	float4 col;
		//	// s来自surf函数，_LightColor0来自Unity
		//	//col.rgb = s.Albedo * _LightColor0.rgb * (difLight * atten * 2);
		//	//col.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 2);
		//	col.rgb = s.Albedo * _LightColor0.rgb * (ramp);
		//	col.a = s.Alpha;
		//	return col;
		//}
		ENDCG
	} 
	FallBack "Diffuse"
}
