Shader "rikovmike/YetAnotherVertexJitter"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _JitterAmount ("Jitter Amount", Range (0.0, 0.1)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            float _JitterAmount;

            // Function for rounding coordinates to integer
            float4 JitterVertex(float4 clipPos, float jitterAmount)
            {
                // Apply quantization only to positions in clip space (screen coordinates)
                clipPos.xy = round(clipPos.xy / jitterAmount) * jitterAmount;
                return clipPos;
            }

            v2f vert(appdata v)
            {
                v2f o;
                float4 clipPos = UnityObjectToClipPos(v.vertex);
                // Call function for "shaking" vertices
                o.pos = JitterVertex(clipPos, _JitterAmount);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}