Shader "Unlit/Galaxy"
{
    Properties
    {
        _MainTex ("Noise", 2D) = "white" {}
        _Color ("Masked Color",COLOR) = (1,1,1,1)
        _Internal_Color("internal Color",COLOR)= (1,1,1,1)
        _scale("ring scale",Range(0.,5.)) =0.0
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal: NORMAL;
                float3 viewDir:TEXCOORD1;
                float4 ScreenPos: TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _scale;
            v2f vert (appdata v)
            {
                v2f o;

                v.vertex.xz+=smoothstep(.1,1,abs(1-abs(dot(v.normal,float3(0,1,0)))))*_scale;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(ObjSpaceViewDir(v.vertex));
                o.ScreenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            float4 _Color,_Internal_Color;
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float2 ScreenPos = i.ScreenPos.xy/i.ScreenPos.w;
                float fresnel = saturate(dot(i.normal,i.viewDir));
                float InvFres = abs(1-fresnel);
                fixed col = tex2D(_MainTex,ScreenPos*5);
                float4 masked = saturate(float4(1,1,1,1)*abs(1-col)*step(.2,fresnel)+smoothstep(.5,.6,fresnel));
                float4 InvMask = abs(1-masked);
                // apply fog
                return masked*_Internal_Color+InvMask*+_Color;//+fresnel;
            }
            ENDCG
        }
    }
}
