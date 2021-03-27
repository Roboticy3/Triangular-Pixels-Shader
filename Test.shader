Shader "Custom/Test"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _SizeX ("SizeX", Range(0.001,1)) = 1.0
        _SizeY ("SizeY", Range(0.001,1)) = 1.0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

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
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 fraction (float4 vec, float4 size)
            {
                return float4(vec.x % size.x, vec.y % size.y, vec.z % size.z, vec.w % size.w);
            }

            sampler2D _MainTex;
            uniform sampler2D _LastCameraDepthTexture;

            float _Dscale;
            float _Dfreq;

            float _Dtris;

            float _SizeX;
            float _SizeY;

            float _Random[1023];

            float minDepth = 1000000;

            //convert uvs to square grid
            float2 squareuvs(float2 d, out float2 p)
            {
                //separate screen into squares
                p = fraction(float4(d, 1, 1), float4(_SizeX, _SizeY, 1, 1)).xy;
                
                //adjust squares for position
                float2 q = d - p;

                return q;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {   
                float2 d = i.uv;

                float2 p = float2(0, 0);
                float2 q = squareuvs(d, p);

                //***adjust corners of squares randomly and smoothly with random array
                //call random value from array

                //flip q in one dimension
                float shift = _Random[q.x * 1023];
                float2 qmod = float2(_Random[q.x * 1023] / (_SizeX / _SizeY), _Random[q.y * 1023] / (_SizeY / _SizeX)) * float2(_SizeX, _SizeY);

                //add qmod to d
                float2 d2 = d + float2(d.y * _Random[q.y * 1023] * _SizeX / 4, d.x * _Random[q.x * 1023] * _SizeY / 4);

                //***wizardry (changes square size by distance)
                float depth = UNITY_SAMPLE_DEPTH(tex2D(_LastCameraDepthTexture, d));
                depth = Linear01Depth(depth) * 50;

                float2 p2 = fraction(float4(d2, 1, 1), float4(_SizeX, _SizeY, 1, 1)).xy;
                float2 q2 = d2 - p2;

                //detect how tris should be drawn
                const fixed4 up = fixed4(0.666, 0.333, 0, 1), down = fixed4(0.333, 0.666, 0, 1);

                //calculate whether triangle will be in the up or down state with a linear equation
                float b = (p2.x) / _SizeX > (-p2.y + _SizeY) / _SizeY;

                //use up down state to choose between colors
                fixed4 col;
                float2 tris = up * b + down * (1 - b);

                float2 final = q2 + tris * float2(_SizeX, _SizeY);

                minDepth -= (minDepth - depth) * depth < minDepth;

                col = tex2D(_MainTex, final);
                //col = fixed4(q2, 1, 1);


                return col;
            }
            ENDCG
        }
    }
}
