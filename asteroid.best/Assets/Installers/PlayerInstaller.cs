using System;
using UnityEngine;
using Zenject;

public class PlayerInstaller : MonoInstaller
{

    [SerializeField]
    Settings _settings = null;

    public override void InstallBindings()
    {
        Container.BindInterfacesTo<InputHandler>().AsSingle();
        Container.Bind<InputHandler.InputState>().AsSingle();
        Container.Bind<Player>().AsSingle().WithArguments(_settings.Rigidbody);
        Container.Bind<ShootHandler>().AsSingle();

        Container.DeclareSignal<ShootSignal>();
        Container.BindSignal<ShootSignal>().ToMethod<ShootHandler>(x => x.Shoot).FromResolve();

    }

    [Serializable]
    public class Settings
    {
        public Rigidbody Rigidbody;
    }
}
