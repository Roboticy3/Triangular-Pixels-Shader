using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplaceShader : MonoBehaviour
{
    public Material EffectMaterial;

    public bool sendAspect, sendRandom;

    public string xSize, ySize, randomArray;

    [Range(0.0001f, 1f)]
    public float size;

    public Camera cam;

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        Graphics.Blit(src, dst, EffectMaterial);
    }

    void Start()
    {
        sendRandom = true;
    }

    float[] RandomArray()
    {
        float[] random = new float[1023];

        for (int i = 0; i < 1023; i++)
        {
            random[i] = Random.Range(-1f, 1f);
        }

        return random;
    }


    void Update()
    {

        if (sendAspect)
        {
            float x = cam.aspect;

            EffectMaterial.SetFloat(xSize, (Mathf.Pow(size,2))/x);
            EffectMaterial.SetFloat(ySize, Mathf.Pow(size,2));
        }

        if (sendRandom)
        {
            sendRandom = false;

            EffectMaterial.SetFloatArray(randomArray, RandomArray());
        }
    }

}
