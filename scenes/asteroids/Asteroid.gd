extends RigidBody2D

export (PackedScene) var hit_effect


func _ready():
	add_to_group('asteroid')


func hit_by_bullet(position, rotation, _damage):
	var hit_fx = hit_effect.instance()
	hit_fx.position = position
	hit_fx.rotation = rotation
	self.get_parent().add_child(hit_fx)


func _integrate_forces(state):
	var transformation = $ScreenWrappable.screen_wrapped_transformation(state.get_transform())
	state.set_transform(transformation)
