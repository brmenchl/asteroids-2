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
        _bulletFactory.Create(
          _player.Transform.position + _player.Transform.forward * _settings.MuzzleDistance,
          _player.Transform.rotation
        );
    }

    [Serializable]
    public class Settings
    {
        public float MuzzleDistance;
    }
}
