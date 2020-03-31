class_name Controller
extends Node

var target: Node = null setget set_target


func _unhandled_key_input(_event: InputEventKey) -> void:
	if Input.is_action_pressed(get_input_name("shoot")):
		if target != null and target.has_method("shoot"):
			target.shoot()


func _process(_delta):
	if target != null:
		if target.has_method("shoot"):
			if Input.is_action_pressed(get_input_name("shoot")):
				target.shoot()
		if target.has_method("move"):
			target.move(
				{
					"left": Input.is_action_pressed(get_input_name("left")),
					"right": Input.is_action_pressed(get_input_name("right")),
					"thrust": Input.is_action_pressed(get_input_name("thrust")),
					"reverse_thrust": Input.is_action_pressed(get_input_name("reverse_thrust"))
				}
			)


func target_lost():
	target = null


func set_target(_target: Node):
	target = _target
	var err = target.connect("tree_exiting", self, "target_lost")
	if err != OK:
		print("error connecting to controller target")


func get_input_name(action: String) -> String:
	return "%s_%s" % [self.name, action]
