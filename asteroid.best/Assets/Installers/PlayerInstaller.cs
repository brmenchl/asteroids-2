using UnityEngine;
using Zenject;

public class PlayerInstaller : MonoInstaller
{
    public override void InstallBindings()
    {
        Container.BindInterfacesTo<InputHandler>().AsSingle();
        Container.Bind<InputHandler.InputState>().AsSingle();
    }
}
