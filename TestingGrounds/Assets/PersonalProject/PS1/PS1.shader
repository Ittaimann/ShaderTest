Shader "Unlit/PS1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _lock ("ps1 range?",Range(0,100))=1
        _color("Color",COLOR) = (1,1,1,1)
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal:NORMAL;
                
            };

            sampler2D _MainTex;
            float4 _MainTex_ST,_color;
            float _lock;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = mul(unity_ObjectToWorld,v.vertex);
                o.vertex = round(o.vertex*_lock)/_lock;
                o.vertex = mul(UNITY_MATRIX_VP,o.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float4 light = saturate(dot(i.normal,normalize(_WorldSpaceLightPos0)))+_LightColor0;
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return _color*light;
            }
            ENDCG
        }
    }
}
