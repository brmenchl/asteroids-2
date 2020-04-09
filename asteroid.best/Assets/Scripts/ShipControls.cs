﻿using UnityEngine;

public class ShipControls : MonoBehaviour
{
    public Rigidbody bullet;
    public float afterburnerPower = 35000;
    public float cruisePower = 22000;
    public float torque = 30;
    public float bulletVelocity = 600;

    private float _thrustInput;
    private float _torqueInput;
    private Rigidbody shipRigidBody;

    void Start()
    {
        shipRigidBody = GetComponent<Rigidbody>();
    }

    void Update()
    {
        _thrustInput = Input.GetAxis("Vertical");
        _torqueInput = Input.GetAxis("Horizontal");
        if (Input.GetButtonDown("Fire1"))
        {
            FireBullet();
        }
    }

    private void FixedUpdate()
    {
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