using System;
using UnityEngine;
using Zenject;

public class TestControls : MonoBehaviour
{
    [Inject]
    public Player.Factory _playerFactory;

    public void Start()
    {
        _playerFactory.Create(new Vector3(0, 0, 0));
        _playerFactory.Create(new Vector3(150, 0, -100));
    }
}
