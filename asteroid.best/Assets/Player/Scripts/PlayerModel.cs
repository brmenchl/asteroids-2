using UnityEngine;
using Zenject;

public class Player
{
    private IControllable _controllable;
    private readonly Transform _transform;
    public bool IsDead { get; private set; } = false;

    public Player(Transform transform, Vector3 position)
    {
        _transform = transform;
        _transform.position = position;
    }

    public void SetControllable(IControllable controllable)
    {
        _controllable = controllable;
        _controllable.GetTransform().SetParent(_transform);
        _controllable.GetTransform().SetPositionAndRotation(_transform.position, _transform.rotation);
    }

    public void AddForce(Vector3 force)
    {
        if (_controllable != null)
            _controllable.AddForce(force);
    }
    public void AddTorque(Vector3 torque)
    {
        if (_controllable != null)
            _controllable.AddTorque(torque);
    }

    public Transform GetTransform()
    {
        return _controllable.GetTransform();
    }

    public float Health
    {
        get
        {
            if (_controllable != null)
            {
                return _controllable.Health;
            }
            else
            {
                return 0.0f;
            }
        }
    }

    public void Die()
    {
        IsDead = true;
        _controllable.Die();
        _controllable = null;
    }

    public class Factory : PlaceholderFactory<Vector3, Player> { }

}
