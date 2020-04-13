using UnityEngine;
using Zenject;

public class GameInstaller : MonoInstaller
{
    public GameObject BulletPrefab;
    public override void InstallBindings()
    {
        SignalBusInstaller.Install(Container);

        // Bullet
        Container.BindFactory<Vector3, Quaternion, Bullet, Bullet.Factory>()
            .FromMonoPoolableMemoryPool(x =>
                x.FromComponentInNewPrefab(BulletPrefab)
                .WithGameObjectName("Bullet")
                .UnderTransformGroup("Bullets")
            );

    }
}

