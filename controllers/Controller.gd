class_name Controller
extends Node

var target: Node = null


func _unhandled_input(_p_event: InputEvent) -> void:
	if Input.is_action_pressed(get_input_name("shoot")):
		if target.has_method("shoot"):
			target.shoot()


func _process(_delta):
	target.move(
		{
			"left": Input.is_action_pressed(get_input_name("left")),
			"right": Input.is_action_pressed(get_input_name("right")),
			"thrust": Input.is_action_pressed(get_input_name("thrust")),
			"reverse_thrust": Input.is_action_pressed(get_input_name("reverse_thrust"))
		}
	)


func get_input_name(action: String) -> String:
	return "%s_%s" % [self.name, action]
