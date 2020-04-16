using UnityEngine;
using Zenject;

[CreateAssetMenu(fileName = "GameSettingsInstaller", menuName = "Installers/GameSettingsInstaller")]
public class GameSettingsInstaller : ScriptableObjectInstaller<GameSettingsInstaller>
{
    public Bullet.Settings Bullet;
    public Ship.Settings Ship;

    public HealthDisplay.Settings HealthDisplay;
    public ShootHandler.Settings Shooting;

    public override void InstallBindings()
    {
        Container.BindInstance(Bullet).IfNotBound();
        Container.BindInstance(Ship).IfNotBound();
        Container.BindInstance(Shooting).IfNotBound();
        Container.BindInstance(HealthDisplay).IfNotBound();
    }
}
