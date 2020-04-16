using System;
using UnityEngine;
using UnityEngine.UI;
using Zenject;

public class HealthDisplay : MonoBehaviour
{
    Player _player;
    Settings _settings;

    [SerializeField]
    public Slider slider;

    public GameObject healthBarUI;

    [Inject]
    public void Construct(Player player, Settings settings)
    {
        _player = player;
        _settings = settings;
        slider.value = CalculateHealth();
    }

    private void Update()
    {
        slider.value = CalculateHealth();
        var playerPosition = _player.GetTransform().position;
        healthBarUI.transform.position = new Vector3(playerPosition.x, 0.0f, playerPosition.z + _settings.BarZOffset);
    }

    private float CalculateHealth() => _player.Health / 100; // where to put max health

    [Serializable]
    public class Settings
    {
        public float BarZOffset;
    }
}
