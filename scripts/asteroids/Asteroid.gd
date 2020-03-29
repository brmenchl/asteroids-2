extends RigidBody2D

export (PackedScene) var hit_effect


func _ready():
	add_to_group('asteroid')


func hit_by_bullet(position):
	var hit_fx = hit_effect.instance()
	hit_fx.position = position
	self.get_parent().add_child(hit_fx)
