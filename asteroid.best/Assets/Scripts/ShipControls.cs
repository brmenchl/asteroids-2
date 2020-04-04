using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShipControls : MonoBehaviour
{
    public Rigidbody2D shipRigidBody;
    public float thrustPower;
    public float torque;
    
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
        
    }

    private void FixedUpdate()
    {
        // frame independent update for physics
        shipRigidBody.AddRelativeForce(Vector2.up * (_thrustInput * thrustPower));
        shipRigidBody.AddTorque(_torqueInput * torque * -1);
    }
}
