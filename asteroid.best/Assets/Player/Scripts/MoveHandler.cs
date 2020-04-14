using System;
using UnityEngine;
using Zenject;

public class MoveHandler : IFixedTickable
{
    readonly InputState _inputState;

    readonly Player _player;

    public MoveHandler(
      Player player,
      InputState inputState
    )
    {
        _player = player;
        _inputState = inputState;
    }

    public void FixedTick()
    {
        if (!_player.IsDead)
        {
            _player.AddTorque(Vector3.up * _inputState.horizontal);
            _player.AddForce(Vector3.forward * _inputState.vertical);
        }
    }
}
