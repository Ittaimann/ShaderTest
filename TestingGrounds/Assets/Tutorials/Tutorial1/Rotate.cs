using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    Transform trans; 
    public float speed;
    void Awake()
    {
        trans = gameObject.GetComponent<Transform>();
    }

    void Update()
    {
        trans.eulerAngles =new Vector3 (trans.rotation.eulerAngles.x,trans.rotation.eulerAngles.y+speed*Time.deltaTime,trans.rotation.eulerAngles.z);
    }
}
