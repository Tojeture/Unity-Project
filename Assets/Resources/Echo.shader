// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Echolocation" {
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Amp("Amplitude", float) = 0
        _Trace ("Trace",float) = 0
        _OutlineColor("OutlineColor",Color) = (1,1,1,1)
		_OutlineWidth("Outline Width", Range(1.0,10.0)) = 1.1
    }
    SubShader {
    	Tags{
			"Queue" = "Transparent"
		}

		Pass
		{
			Name "OUTLINE"

			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD1;
			};

			float _Amp;
			float _OutlineWidth;
			float4 _OutlineColor;
			sampler2D _OutlineTex;

			int _ArrayLength = 10;
            float _RadiusArray[10];
            float3 _CenterArray[10];

			v2f vert(appdata IN){
				v2f o;
				o.worldPos = mul(unity_ObjectToWorld, IN.vertex).xyz;
				float width = 1;
				for (int j = 0; j < _ArrayLength; j++)
				{
					float dist = distance(_CenterArray[j],o.worldPos);
					if(_RadiusArray[j]>dist){
						width = _OutlineWidth;
					}
				}
				IN.vertex.xyz *= width;


				o.pos = UnityObjectToClipPos(IN.vertex);



				
				return o;
			}

			fixed4 frag(v2f IN) : SV_TARGET
			{
				for (int j = 0; j < _ArrayLength; j++)
				{
					float dist = distance(_CenterArray[j],IN.worldPos);
					if(_RadiusArray[j]>dist){
						return _OutlineColor*_Amp * (dist/pow(_RadiusArray[j],2.5));
				    }
				}
				return fixed4(0,0,0,1.0);
			}
			ENDCG
		}

        Pass {
            Tags { "RenderType"="Opaque" }
       
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _Color;
            float _Amp;
            float _Trace;

            int _ArrayLength = 10;
            float _RadiusArray[10];
            float3 _CenterArray[10];


            struct v2f {
            	float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };
 
            v2f vert(appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = v.vertex.xy;
                return o;
            }
 
            fixed4 frag(v2f IN) : COLOR {
				for (int j = 0; j < _ArrayLength; j++)
				{
					float dist = distance(_CenterArray[j],IN.worldPos);
					float radiusDistance = _RadiusArray[j]-dist;
					if(radiusDistance < 0){
						radiusDistance = 0;
					}
					if(radiusDistance < 5 && radiusDistance > 0){
						float ofset = 1 - (_RadiusArray[j]/100);
				    	return (_Color*_Amp) * (dist/pow(_RadiusArray[j],_Trace)) * (ofset);
				    }
				}
                return fixed4(0,0,0,1.0);
            }
 
            ENDCG
        }
    }
    FallBack "Diffuse"
}
