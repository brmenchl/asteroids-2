using UnityEngine;
using Zenject;

public class ShipControls : MonoBehaviour
{
    public Rigidbody bullet;
    public float afterburnerPower = 35000;
    public float cruisePower = 22000;
    public float torque = 30;
    public float bulletVelocity = 600;
    public Transform muzzle;

    private Rigidbody shipRigidBody;

    [Inject]
    readonly InputHandler.InputState _inputState;

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
        Rigidbody bulletInstance = Instantiate(this.bullet, muzzle.position, muzzle.rotation);
        bulletInstance.velocity = muzzle.forward * bulletVelocity;
    }
}
