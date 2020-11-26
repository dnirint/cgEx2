Shader "CG/BlinnPhong"
{
    Properties
    {
        _DiffuseColor ("Diffuse Color", Color) = (0.14, 0.43, 0.84, 1)
        _SpecularColor ("Specular Color", Color) = (0.7, 0.7, 0.7, 1)
        _AmbientColor ("Ambient Color", Color) = (0.05, 0.13, 0.25, 1)
        _Shininess ("Shininess", Range(0.1, 50)) = 10
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                // From UnityCG
                uniform fixed4 _LightColor0; 

                // Declare used properties
                uniform fixed4 _DiffuseColor;
                uniform fixed4 _SpecularColor;
                uniform fixed4 _AmbientColor;
                uniform float _Shininess;

                struct appdata
                { 
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float3 posWorld: TEXCOORD0;
                    float3 normalDir: TEXCOORD1;
                };


                v2f vert (appdata input)
                {
                    v2f output;
                    output.posWorld = mul(unity_ObjectToWorld,input.vertex);
                    output.normalDir = normalize(input.normal);
                    output.pos = UnityObjectToClipPos(input.vertex);
                    return output;
                }


                float4 frag(v2f input) : COLOR
                {
                    float3 n = input.normalDir;

                    float3 v = normalize(_WorldSpaceCameraPos.xyz);

                    float3 l = normalize(_WorldSpaceLightPos0.xyz);

                    float3 h = normalize((v+l)/2.0);

                    float3 color_a = _AmbientColor.rgb * _LightColor0.rgb;
 
                    float3 color_d = _LightColor0.rgb * _DiffuseColor.rgb * max(0.0, dot(n, l));

                    float3 color_s = _LightColor0.rgb  * _SpecularColor.rgb * pow(max(0.0, dot(h, n)), _Shininess);

                    return float4(color_a + color_d  + color_s, 1.0);
                }

            ENDCG
        }
    }
}
