using System;
using UnityEngine;
using Zenject;

public class Ship : MonoBehaviour, IControllable
{
    [Inject]
    readonly Settings _settings;

    private Rigidbody _rigidbody;
    public float Health { get; private set; } = 100.0f;

    public void Start()
    {
        _rigidbody = GetComponent<Rigidbody>();
        if (_rigidbody == null)
        {
            throw new Exception("YOU GOTTA HAVE A RIGID BODY");
        }
    }


    public void TakeDamage(float damage)
    {
        Health = Mathf.Max(0.0f, Health - damage);
    }

    public void Die()
    {
        Destroy(gameObject);
    }

    public void AddForce(Vector3 force) => _rigidbody.AddRelativeForce(force * _settings.CruisePower);

    public void AddTorque(Vector3 torque) => _rigidbody.AddRelativeTorque(torque * _settings.TurnPower);

    public Transform GetTransform() => GetComponent<Rigidbody>().transform;

    public class Factory : PlaceholderFactory<Ship> { }

    [Serializable]
    public class Settings
    {
        public float AfterburnerPower;
        public float CruisePower;
        public float TurnPower;
    }
}
