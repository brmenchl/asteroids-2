using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Users;
using Zenject;


public class PlayerFacade : MonoBehaviour
{

    InputState _inputState;
    SignalBus _signalBus;

    Player _player;

    [Inject]
    public void Contruct(InputState inputState, SignalBus signalBus, Player player)
    {
        _inputState = inputState;
        _signalBus = signalBus;
        _player = player;
        _player.SetControllable(GetComponentInChildren<Ship>());
    }

    void Start()
    {
        var player = GetComponent<PlayerInput>();

        // Discard existing assignments.
        player.user.UnpairDevices();

        // Assign devices and control schemes.
        InputUser.PerformPairingWithDevice(Keyboard.current, user: player.user);

        if (player.playerIndex == 0)
        {
            player.user.ActivateControlScheme("KeyboardLeft");
        }
        else if (player.playerIndex == 1)
        {
            player.user.ActivateControlScheme("KeyboardRight");
        }
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
