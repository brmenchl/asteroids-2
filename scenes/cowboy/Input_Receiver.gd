extends Node

export var player_id = ''
var shoot_input = get_input_name("shoot")
var left_input = get_input_name("left")
var right_input = get_input_name("right")
var thrust_input = get_input_name("thrust")

func get_input_name(action: String):
	if !player_id.empty():
		return "player" + "_" + player_id + "_" + action
	else:
		return "player" + "_" + action

func process_check_input(delta: float, callbacks):
	if Input.is_action_pressed(shoot_input):
		callbacks.shoot()

	if Input.is_action_pressed(left_input):
		callbacks.turn_left(delta)
		
	if Input.is_action_pressed(right_input):
		callbacks.turn_right(delta)

	if Input.is_action_pressed(thrust_input):
		callbacks.thrust(delta)
