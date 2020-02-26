using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SortOrder : MonoBehaviour {

    public Canvas parentCanvas;
    public RectTransform maskRect;
	// Use this for initialization
	void Start () {

        Renderer[] renders = GetComponentsInChildren<Renderer>(true);
        foreach(var render in renders)
        {
            render.sortingOrder = parentCanvas.sortingOrder + 10;
        }

        Vector3[] corners = new Vector3[4];
        var particleRenders = GetComponentsInChildren<ParticleSystemRenderer>();
        maskRect.GetWorldCorners(corners);
        Vector4 v4 = new Vector4(corners[0].x, corners[0].y, corners[2].x, corners[2].y);
        ParticleSystemRenderer Particlerender;
        for(int i = 0; i< particleRenders.Length; i++)
        {
            Particlerender = particleRenders[i];
            if(Particlerender != null && Particlerender.material != null)
            {
                Particlerender.material.SetVector("_ClipRect", v4);
                Particlerender.material.EnableKeyword("UI_CLIP");
            }
        }
	}
	
}
