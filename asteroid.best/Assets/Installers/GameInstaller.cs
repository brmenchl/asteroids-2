using UnityEngine;
using Zenject;

public class GameInstaller : MonoInstaller
{
    public GameObject BulletPrefab;
    public override void InstallBindings()
    {
        // Player
        Container.BindInterfacesTo<InputHandler>().AsSingle();
        Container.Bind<InputHandler.InputState>().AsSingle();
        Container.Bind<PlayerModel>().AsSingle();

        // Bullet
        Container.BindFactory<Transform, float, Bullet, Bullet.Factory>()
            .FromMonoPoolableMemoryPool(x =>
                x.FromComponentInNewPrefab(BulletPrefab)
                .WithGameObjectName("Bullet")
                .UnderTransformGroup("Bullets")
            );

    }
}

