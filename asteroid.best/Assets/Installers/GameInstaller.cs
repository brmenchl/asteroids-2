using UnityEngine;
using Zenject;

public class GameInstaller : MonoInstaller
{
    public GameObject BulletPrefab;
    public GameObject ShipPrefab;
    public GameObject PlayerPrefab;

    public override void InstallBindings()
    {
        SignalBusInstaller.Install(Container);

        // Bullet
        Container.BindFactory<Vector3, Quaternion, Bullet, Bullet.Factory>()
            .FromPoolableMemoryPool<Vector3, Quaternion, Bullet, Bullet.Pool>(x =>
                x.FromComponentInNewPrefab(BulletPrefab)
                .WithGameObjectName("Bullet")
                .UnderTransformGroup("Bullets")
            );

        // Player
        Container.BindFactory<Vector3, Player, Player.Factory>()
            .FromSubContainerResolve()
            .ByNewPrefabInstaller<PlayerInstaller>(PlayerPrefab);

        // Ship
        Container.BindFactory<Ship, Ship.Factory>()
          .FromComponentInNewPrefab(ShipPrefab);

        // Cowboy
    }

}
