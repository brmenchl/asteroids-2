extends RigidBody2D

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

func process_check_input(delta: float):
	if Input.is_action_pressed(shoot_input):
		shoot()

	if Input.is_action_pressed(left_input):
		turn_left(delta)
		
	if Input.is_action_pressed(right_input):
		turn_right(delta)

	if Input.is_action_pressed(thrust_input):
		thrust(delta)

func shoot():
	pass

func turn_left(_delta: float):
	pass

func turn_right(_delta: float):
	pass

func thrust(_delta: float):
	pass
