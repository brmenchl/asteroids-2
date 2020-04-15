using System;
using UnityEngine;
using Zenject;

public class TestControls : MonoBehaviour
{
    [Inject]
    public Player.Factory _playerFactory;

    public void Start()
    {
        _playerFactory.Create();
    }
    // public void Update()
    // {
    //     if (Input.GetKeyDown(KeyCode.Space))
    //     {
    //         _playerFactory.Create();
    //     }
    // }
}
