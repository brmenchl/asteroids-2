using System;
using UnityEngine;
using UnityEngine.InputSystem;
using Zenject;

public class InputHandler : PlayerControl.IPlayerActions, IDisposable
{
    readonly InputState _inputState;
    readonly SignalBus _signalBus;
    readonly PlayerControl _controls;

    public InputHandler(
      InputState inputState,
      SignalBus signalBus
      )
    {
        _inputState = inputState;
        _signalBus = signalBus;
        _controls = new PlayerControl();
        _controls.Player.Enable();
        _controls.Player.SetCallbacks(this);
    }

    public void Dispose()
    {
        _controls.Player.Disable();
    }

    public void OnThrust(InputAction.CallbackContext context)
    {
        _inputState.vertical = context.ReadValue<float>();
    }

    public void OnTurn(InputAction.CallbackContext context)
    {
        _inputState.horizontal = context.ReadValue<float>();
    }

    public void OnFire(InputAction.CallbackContext context)
    {
        if (context.started) _signalBus.Fire<ShootSignal>();
    }
}
