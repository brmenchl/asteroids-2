using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AsteroidTumble : MonoBehaviour
{
    public float tumbleSpeed;
    void Start()
    {
        GetComponent<Rigidbody>().angularVelocity = Random.insideUnitSphere * tumbleSpeed;
    }


}
