using UnityEngine;
using Zenject;

public class PlayerInstaller : Installer<Vector3, PlayerInstaller>
{
    Vector3 _startPosition;
    public PlayerInstaller(Vector3 startPosition)
    {
        _startPosition = startPosition;
    }

    public override void InstallBindings()
    {
        Container.Bind<Transform>().FromComponentOnRoot();
        Container.Bind<Player>().AsSingle().WithArguments(_startPosition);
        Container.Bind<InputState>().AsSingle();
        Container.BindInterfacesAndSelfTo<MoveHandler>().AsSingle();
        Container.BindInterfacesAndSelfTo<HealthWatcher>().AsSingle();
        Container.Bind<ShootHandler>().AsSingle();

        Container.DeclareSignal<ShootSignal>();
        Container.BindSignal<ShootSignal>().ToMethod<ShootHandler>(x => x.Shoot).FromResolve();

    }
}
