using System;
using UnityEngine;
using Zenject;

public class ShipControls : MonoBehaviour
{
    private Rigidbody shipRigidBody;
    private float _lastFireTime;

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

    public void Update()
    {
        if (_playerModel.Health <= 0)
        {
            Destroy(gameObject);
        }
    }

    private void FixedUpdate()
    {
        shipRigidBody.AddRelativeTorque(Vector3.up * (_inputState.horizontal * _settings.Torque));
        shipRigidBody.AddRelativeForce(Vector3.forward * (_inputState.vertical * _settings.CruisePower));
        if (_inputState.isFiring && Time.realtimeSinceStartup - _lastFireTime > (1 / _settings.FireRate))
        {
            _lastFireTime = Time.realtimeSinceStartup;
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
        public float FireRate;
    }
}
