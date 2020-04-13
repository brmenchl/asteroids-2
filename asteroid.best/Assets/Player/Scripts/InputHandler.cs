using UnityEngine;
using Zenject;

public class InputHandler : ITickable
{
    readonly InputState _inputState;
    readonly SignalBus _signalBus;

    public InputHandler(InputState inputState, SignalBus signalBus)
    {
        _inputState = inputState;
        _signalBus = signalBus;
    }

    public void Tick()
    {
        _inputState.vertical = Input.GetAxis("Vertical");
        _inputState.horizontal = Input.GetAxis("Horizontal");
        if (Input.GetButtonDown("Fire1"))
        {
            _signalBus.Fire<ShootSignal>();
        }
    }

    public class InputState
    {
        public float horizontal;

        public float vertical;

        public bool isFiring;
    }
}
