using UnityEngine;

public class PlayerModel
{
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
