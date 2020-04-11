using UnityEngine;
using Zenject;

public class InputHandler : ITickable
{
    readonly InputState _inputState;

    public InputHandler(InputState inputState)
    {
        _inputState = inputState;
    }

    public void Tick()
    {
        _inputState.vertical = Input.GetAxis("Vertical");
        _inputState.horizontal = Input.GetAxis("Horizontal");
        _inputState.isFiring = Input.GetButton("Fire1");
    }

    public class InputState
    {
        public float horizontal;

        public float vertical;

        public bool isFiring;
    }
}
