using Zenject;

public class HealthWatcher : ITickable
{
    readonly Player _player;

    public HealthWatcher(Player player)
    {
        _player = player;
    }

    public void Tick()
    {
        if (!_player.IsDead && _player.Health <= 0)
        {
            _player.Die();
        }
    }
}
