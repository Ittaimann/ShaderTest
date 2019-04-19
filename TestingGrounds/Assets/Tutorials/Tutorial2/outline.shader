Shader "Tutorial/Tutorial2/Outline"
{
    Properties
    {
        [PerRendererData]_MainTex ("Texture", 2D) = "white" {}
        _Noise ("Noise", 2D) = "white" {}
        _Brightness("Outline Brightness", Range(0,8)) = 3.2

        _Tint("color tint",Color) = (1,1,1,1)
        _outline("outline Color",Color ) = (1,1,1,0)
        _outLineSize("Outline Width", Range(0,0.5)) = 0.003 
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
        
     Pass // Outline
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex,_Noise;
            float4 _MainTex_ST,_Noise_ST;
            float4 _outline;
            float _outLineSize,_Brightness;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.vertex = UnityPixelSnap (o.vertex); // get it to be pixel snapped properly
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                 // to get the alpha out
                fixed4 col = tex2D(_MainTex, i.uv); // used for masking
                col.rgb *= col.a;
                      // Move sprite in 4 directions according to width, we only care about the alpha
                float spriteLeft = tex2D(_MainTex,i.uv + float2(_outLineSize, 0)).a;
                float spriteRight = tex2D(_MainTex,i.uv - float2(_outLineSize,  0)).a;
                float spriteBottom = tex2D(_MainTex,i.uv + float2( 0 ,_outLineSize)).a;
                float spriteTop = tex2D(_MainTex, i.uv - float2( 0 , _outLineSize)).a;
               
                // then combine
                float4 result = (spriteRight + spriteLeft + spriteTop+ spriteBottom);
                // delete original alpha to only leave outline
                result.rgb *= (1-col.a);
                // add color and brightness
                float4 outlines = result * _outline;             
                col.rgb = col.rgb + outlines;
                return col;
            }
            ENDCG
        }
     
    }
}
