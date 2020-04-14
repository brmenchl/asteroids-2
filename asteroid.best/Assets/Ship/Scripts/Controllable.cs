using UnityEngine;

public interface IControllable
{
    void AddForce(Vector3 force);
    void AddTorque(Vector3 torque);

    void Die();

    float Health { get; }

    Transform GetTransform();
}
