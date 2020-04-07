using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShipControls : MonoBehaviour
{
    public Rigidbody shipRigidBody;
    public Rigidbody bullet;
    public float afterburnerPower = 35000;
    public float cruisePower = 22000;
    public float torque = 30;
    public float bulletVelocity = 600;
    
    private float _thrustInput;
    private float _torqueInput;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        _thrustInput = Input.GetAxis("Vertical");
        _torqueInput = Input.GetAxis("Horizontal");
        if (Input.GetButtonDown("Fire1"))
        {
            FireBullet();
            print("supsupsup");
        }
    }

    private void FixedUpdate()
    {
        // frame independent update for physics
        shipRigidBody.AddRelativeTorque(Vector3.up * (_torqueInput * torque));
        shipRigidBody.AddRelativeForce(Vector3.forward * (_thrustInput * cruisePower));
    }

    void FireBullet()
    {
        var myTransform = transform;
        Rigidbody bulletInstance = Instantiate(this.bullet, myTransform.position, myTransform.rotation);
        bulletInstance.velocity = transform.forward * bulletVelocity;
    }
}
