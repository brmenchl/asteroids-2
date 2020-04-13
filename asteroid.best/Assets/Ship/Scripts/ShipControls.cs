using System;
using UnityEngine;
using Zenject;

public class ShipControls : MonoBehaviour
{
    private Rigidbody shipRigidBody;

    [Inject]
    readonly Settings _settings;

    [Inject]
    readonly InputHandler.InputState _inputState;

    [Inject]
    readonly Bullet.Factory _bulletFactory;

    [Inject]
    readonly PlayerModel _playerModel;

    private void Start()
    {
        shipRigidBody = GetComponent<Rigidbody>();
    }

    public void Tick()
    {
        if (_playerModel.Health <= 0 && !_playerModel.IsDead)
        {
            Destroy(this);
        }
    }

    private void FixedUpdate()
    {
        shipRigidBody.AddRelativeTorque(Vector3.up * (_inputState.horizontal * _settings.Torque));
        shipRigidBody.AddRelativeForce(Vector3.forward * (_inputState.vertical * _settings.CruisePower));
        if (_inputState.isFiring)
        {
            FireBullet();
        }
    }

    public void TakeDamage(float damage)
    {
        _playerModel.TakeDamage(damage);
    }

    void FireBullet()
    {
        _bulletFactory.Create(transform, _settings.MuzzleDistance);
    }

    [Serializable]
    public class Settings
    {
        public float AfterburnerPower;
        public float CruisePower;
        public float Torque;
        public float MuzzleDistance;
    }
}
