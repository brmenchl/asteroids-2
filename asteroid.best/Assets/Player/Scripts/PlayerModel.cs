using UnityEngine;
using Zenject;

public class Player
{
    private IControllable _controllable;
    private readonly Transform _transform;
    public bool IsDead { get; private set; } = false;

    public Player(Ship.Factory shipFactory, Transform transform)
    {
        _transform = transform;

        var ship = shipFactory.Create();
        SetControllable(ship);
    }

    public void SetControllable(IControllable controllable)
    {
        _controllable = controllable;
        GetTransform().SetParent(_transform);
    }

    public void AddForce(Vector3 force) => _controllable.AddForce(force);
    public void AddTorque(Vector3 torque) => _controllable.AddTorque(torque);
    public Transform GetTransform() => _controllable.GetTransform();
    public float Health
    {
        get { return _controllable.Health; }
    }

    public void Die()
    {
        IsDead = true;
        _controllable.Die();
        _controllable = null;
    }

    public class Factory : PlaceholderFactory<Player> { }

}
