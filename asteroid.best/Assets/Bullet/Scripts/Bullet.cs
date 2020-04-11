using System;
using UnityEngine;
using Zenject;

public class Bullet : MonoBehaviour, IPoolable<Vector3, Quaternion, Vector3, IMemoryPool>, IDisposable
{
    IMemoryPool _pool;
    
    public void Dispose()
    {
        _pool.Despawn(this);
    }

    public void OnDespawned()
    {
        _pool = null;
        GetComponent<Rigidbody>().velocity = Vector3.zero;
    }

    public void OnSpawned(Vector3 position, Quaternion rotation, Vector3 velocity, IMemoryPool pool)
    {
        _pool = pool;
        transform.position = position;
        transform.rotation = rotation;
        GetComponent<Rigidbody>().velocity = velocity;
    }

    public class Factory : PlaceholderFactory<Vector3, Quaternion, Vector3, Bullet> { }
}
