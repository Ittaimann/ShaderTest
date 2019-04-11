using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LerpMove : MonoBehaviour
{
    public Transform Spot1;
    public Transform spot2;
    private Material mat;
    // Start is called before the first frame update
   
    void Awake()
    {
        mat = GetComponent<MeshRenderer>().material;
    }
    // Update is called once per frame
    void Update()
    {
        transform.position = Vector3.Lerp(spot2.position,Spot1.position,(Mathf.Sin(Time.time)+1)/2);
        mat.SetFloat("_lock",Mathf.RoundToInt(Mathf.Lerp(2, 50, (Mathf.Sin(Time.time*2.0f) + 1) / 2)));
    }
}
