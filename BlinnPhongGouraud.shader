Shader "CG/BlinnPhongGouraud"
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
                    fixed4 color_d : COLOR0;
                    fixed4 color_a : COLOR1;
                    fixed4 color_s : COLOR2;
                };


                v2f vert (appdata input)
                {
                    v2f output;
                    output.pos = UnityObjectToClipPos(input.vertex);
                    fixed3 l = normalize(input.vertex - _WorldSpaceLightPos0);
                    fixed3 n = normalize(input.normal);
                    fixed3 v = input.vertex - _WorldSpaceCameraPos;
                    fixed3 h = normalize((l + v) / 2);

                    output.color_a = _AmbientColor * _LightColor0;
                    output.color_d = _DiffuseColor * _LightColor0 * max(dot(l, n), 0);
                    output.color_s = _SpecularColor * _LightColor0 * pow(max(dot(h, n), 0), _Shininess);
                    
                    return output;
                }


                fixed4 frag (v2f input) : SV_Target
                {
                    return input.color_d + input.color_a + input.color_s; 
                }

            ENDCG
        }
    }
}
