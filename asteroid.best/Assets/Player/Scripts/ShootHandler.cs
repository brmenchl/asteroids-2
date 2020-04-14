using System;

public class ShootHandler
{
    readonly Bullet.Factory _bulletFactory;
    readonly Settings _settings;
    readonly Player _player;

    public ShootHandler(
      Settings settings,
      Player player,
      Bullet.Factory bulletFactory
      )
    {
        _settings = settings;
        _player = player;
        _bulletFactory = bulletFactory;
    }

    public void Shoot()
    {
        if (!_player.IsDead)
        {
            var baseTransform = _player.GetTransform();
            _bulletFactory.Create(
              baseTransform.position + baseTransform.forward * _settings.MuzzleDistance,
              baseTransform.rotation
            );
        }
    }

    [Serializable]
    public class Settings
    {
        public float MuzzleDistance; // MAYBE MOVE TO SHIP
    }
}
