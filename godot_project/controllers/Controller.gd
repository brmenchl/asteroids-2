class_name Controller
extends Node

var target: Node = null setget set_target


func _process(_delta):
	if target != null:
		if target.has_method("shoot"):
			if Input.is_action_pressed(get_input_name("shoot")):
				target.shoot()
		if target.has_method("secondary"):
			if Input.is_action_pressed(get_input_name("secondary")):
				target.secondary()
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
	if target != null:
		target.disconnect("tree_exiting", self, "target_lost")
	target = _target
	var err = target.connect("tree_exiting", self, "target_lost")
	if err != OK:
		print("error connecting to controller target")


func get_input_name(action: String) -> String:
	return "%s_%s" % [self.name, action]
