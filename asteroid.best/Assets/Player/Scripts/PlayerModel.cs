using UnityEngine;

public class Player
{
    readonly Rigidbody _rigidBody;

    public Player(
        Rigidbody rigidBody
    )
    {
        _rigidBody = rigidBody;
    }

    public Transform Transform
    {
        get { return _rigidBody.transform; }
    }

    public void AddForce(Vector3 force)
    {
        _rigidBody.AddRelativeForce(force);
    }

    public void AddTorque(Vector3 torque)
    {
        _rigidBody.AddRelativeTorque(torque);
    }

    public void TakeDamage(float damage)
    {
        Health = Mathf.Max(0.0f, Health - damage);
        if (Health == 0.0f)
        {
            IsDead = true;
        }
    }

    public bool IsDead { get; private set; } = false;

    public float Health { get; private set; } = 100.0f;

}
