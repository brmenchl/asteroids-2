using UnityEngine;
using Zenject;

public class PlayerInstaller : Installer<PlayerInstaller>
{
    public override void InstallBindings()
    {
        Container.Bind<Transform>().FromComponentOnRoot();
        Container.Bind<Player>().AsSingle();
        Container.Bind<InputState>().AsSingle();
        Container.BindInterfacesAndSelfTo<InputHandler>().AsSingle().NonLazy();
        Container.BindInterfacesAndSelfTo<MoveHandler>().AsSingle();
        Container.BindInterfacesAndSelfTo<HealthWatcher>().AsSingle();
        Container.Bind<ShootHandler>().AsSingle();

        Container.DeclareSignal<ShootSignal>();
        Container.BindSignal<ShootSignal>().ToMethod<ShootHandler>(x => x.Shoot).FromResolve();

    }
}
