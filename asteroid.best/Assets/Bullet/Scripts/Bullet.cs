using System;
using UnityEngine;
using Zenject;

public class Bullet : MonoBehaviour, IPoolable<Vector3, Quaternion, IMemoryPool>
{
    IMemoryPool _pool;
    float _startTime;

    [Inject]
    readonly Settings _settings;

    public void OnDespawned()
    {
        _pool = null;
        GetComponent<Rigidbody>().velocity = Vector3.zero;
    }

    public void OnSpawned(Vector3 position, Quaternion rotation, IMemoryPool pool)
    {
        _pool = pool;
        transform.SetPositionAndRotation(position, rotation);
        GetComponent<Rigidbody>().velocity = transform.forward * _settings.Speed;
        _startTime = Time.realtimeSinceStartup;
    }

    private void Update()
    {
        if (Time.realtimeSinceStartup - _startTime > _settings.LifeTime)
        {
            _pool.Despawn(this);
        }
    }

    public void OnTriggerEnter(Collider other)
    {
        var player = other.GetComponent<ShipControls>();

        if (player != null)
        {
            player.TakeDamage(_settings.Damage);
            _pool.Despawn(this);
        }
    }

    public class Factory : PlaceholderFactory<Vector3, Quaternion, Bullet> { }

    public class Pool : MonoPoolableMemoryPool<Vector3, Quaternion, IMemoryPool, Bullet>
    {
    }

    [Serializable]
    public class Settings
    {
        public float Speed;
        public float LifeTime;
        public float Damage;
    }
}
