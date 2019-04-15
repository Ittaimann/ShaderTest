Shader "Tutorial/Tutorial2/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Noise ("Noise", 2D) = "white" {}

        _Tint("color tint",Color) = (1,1,1,1)
        _outline("outline Color",Color ) = (1,1,1,0)
        _outLineSize("outline size", Range(1,2))=1
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
            float _outLineSize;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex*_outLineSize);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.vertex = UnityPixelSnap (o.vertex); // get it to be pixel snapped properly
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                 // to get the alpha out
                fixed4 col = tex2D(_MainTex, i.uv); // used for masking
                _outline*= col.a*_outline.a;
                
                
                return _outline;
            }
            ENDCG
        }
       Pass{

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

            float4 _Tint;
            float _mitigate;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord , _MainTex);
                o.vertex = UnityPixelSnap (o.vertex); // get it to be pixel snapped properly
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                                
                fixed4 col = tex2D(_MainTex,i.uv);

                // apply fog
                col*=_Tint;
                col.rgb*=col.a; // to get the alpha out
                return col;
            }
            ENDCG
        }
    }
}
