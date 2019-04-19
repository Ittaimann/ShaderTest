Shader "Tutorial/Tutorial2/palleteSwap"
{
    Properties
    {
        [PerRendererData]_MainTex ("Texture", 2D) = "white" {}
        _PalleteTex ("pallete texture", 2D) = "white" {}
    }
    SubShader
    {
    Tags { "QUEUE"="Transparent"  //when to render
           "IGNOREPROJECTOR"="true" // don't know
           "RenderType"="Transparent" // what type of render
           "PreviewType"="Plane" // don't know
           "CanUseSpriteAtlas"="true" } // don't know
        ZWrite Off // don't carent about depth 
        Cull Off // Don't get rid of anything based on the direction we are looking at 
        Blend One OneMinusSrcAlpha // Blend the background and the sprite based on alpha
        Lighting off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
				

            #include "UnityCG.cginc"

       

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex,_PalleteTex;
            float4 _MainTex_ST,_PalleteTex_ST;
           
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord , _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                fixed4 pal = tex2D(_PalleteTex,float2(col.r,0));
                pal.a = col.a;
                pal.rgb*=pal.a;
                return pal;
            }
            ENDCG
        }
    }
}
