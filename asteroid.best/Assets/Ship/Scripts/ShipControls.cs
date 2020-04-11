using UnityEngine;
using Zenject;

public class ShipControls : MonoBehaviour
{
    public float afterburnerPower = 35000;
    public float cruisePower = 22000;
    public float torque = 30;
    public float bulletVelocity = 600;
    public Transform muzzle;

    private Rigidbody shipRigidBody;

    [Inject]
    readonly InputHandler.InputState _inputState;

    [Inject]
    readonly Bullet.Factory _bulletFactory;

    void Start()
    {
        shipRigidBody = GetComponent<Rigidbody>();
    }

    private void FixedUpdate()
    {
        shipRigidBody.AddRelativeTorque(Vector3.up * (_inputState.horizontal * torque));
        shipRigidBody.AddRelativeForce(Vector3.forward * (_inputState.vertical * cruisePower));
        if (_inputState.isFiring)
        {
            FireBullet();
        }
    }

    void FireBullet()
    {
        var velocity = muzzle.forward * bulletVelocity;
        _bulletFactory.Create(muzzle.position, muzzle.rotation, velocity);
    }
}
