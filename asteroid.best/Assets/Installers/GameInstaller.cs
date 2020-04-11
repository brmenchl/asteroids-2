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

        // Bullet
        Container.BindFactory<Vector3, Quaternion, Vector3, Bullet, Bullet.Factory>()
            .FromMonoPoolableMemoryPool(x =>
                x.FromComponentInNewPrefab(BulletPrefab)
                .UnderTransformGroup("Bullets")
            );

    }
}
