using System;
using UnityEngine;
using Zenject;

public class ShipControls : MonoBehaviour
{
    [Inject]
    Settings _settings;

    [Inject]
    InputHandler.InputState _inputState;

    [Inject]
    Player _playerModel;

    public void Update()
    {
        if (_playerModel.Health <= 0)
        {
            Destroy(gameObject);
        }
    }

    private void FixedUpdate()
    {
        _playerModel.AddTorque(Vector3.up * (_inputState.horizontal * _settings.Torque));
        _playerModel.AddForce(Vector3.forward * (_inputState.vertical * _settings.CruisePower));
    }

    public void TakeDamage(float damage)
    {
        _playerModel.TakeDamage(damage);
    }

    [Serializable]
    public class Settings
    {
        public float AfterburnerPower;
        public float CruisePower;
        public float Torque;
    }
}
