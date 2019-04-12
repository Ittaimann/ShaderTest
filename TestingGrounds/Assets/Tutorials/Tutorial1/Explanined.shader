Shader "Tutorial1/Explanined" // this is the decleratinon of the shader for unity, essentially where is this in the menu
{
    Properties // The properties availble to us in the material menu
    {
        _MainTex ("Texture", 2D) = "white" {}
        _color("color",Color) = (1,1,1,1) // white
        _slider("slider", Range(0,1))= .5
    }
    SubShader // this is so we can declare multiple types of shaders so we can write multiple kinds for different possible hardwaare
    {
        Tags { "RenderType"="Opaque" } // Tags system for unity, kinda comlicated :(
        LOD 100 // LOD or level of detail for hot swapping different levels on runtime

        Pass // a pass is equivlante to one draw call, essentially draw this once.
        {
            CGPROGRAM // Decleration of a cg program, this is where the actually shader logic is placed. 
            // pre processor declaring the vertex function and fragment function as vert and frag
            #pragma vertex vert 
            #pragma fragment frag
            // make fog work, /shrug
            #pragma multi_compile_fog

            // Include file for unity shader tools, gotta have this pretty much always unless you have a 
            // library that derived from it
            #include "UnityCG.cginc"

            // data from the object we are shading. 
            struct appdata
            {
                float4 vertex : POSITION; // vertex positions
                float2 uv : TEXCOORD0; // UV coordinates, uh... I  uh... ya UV's
            };

            struct v2f // struct for location on screen
            {
                float2 uv : TEXCOORD0; // yep
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION; // screen space position
            };

            sampler2D _MainTex; // declaring texture 
            float4 _MainTex_ST; // texture scale and tile

            v2f vert (appdata v) // vert function sets up the v2f struct 
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // object to clip
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); // texture can now be on the uv
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target // color value at the screen pixel
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv); // col is a fixed4 (think of it as a tuple of four fixed).
                                                    // and we are sampling _Maintex and using the objects uv map to figure 
                                                    // out where things need to  go
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col; // returned pixel value
            }
            ENDCG // end the cg program
        }
    }
}
