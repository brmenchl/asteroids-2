class_name Bullet
extends Area2D

export var speed = 750
export var damage = 10
var vel = Vector2()


func _ready():
	add_to_group('bullet')


func start_at(rot, pos):
	rotation = rot
	position = pos
	vel = Vector2(speed, 0).rotated(rot - PI / 2)


func _physics_process(delta):
	position += vel * delta


func _on_Lifetime_timeout():
	queue_free()


func hittable_by_bullet(body):
	var groups_hittable_by_bullet = ["asteroid", "ship"]
	for group in groups_hittable_by_bullet:
		if body.is_in_group(group):
			return true
	return false


func _on_Bullet_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if hittable_by_bullet(body):
		body.call_deferred("hit_by_bullet", position, rotation, damage)
		queue_free()
