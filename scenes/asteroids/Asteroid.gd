class_name Asteroid	
extends RigidBody2D

export (PackedScene) var hit_effect
onready var screensize := get_viewport().get_visible_rect().size


func hit_by_bullet(position, rotation, _damage):
	var hit_fx = hit_effect.instance()
	hit_fx.position = position
	hit_fx.rotation = rotation
	self.get_parent().add_child(hit_fx)

func _integrate_forces(state):
	state.angular_velocity = 0

