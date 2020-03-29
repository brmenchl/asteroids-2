extends Area2D
class_name Bullet

var vel = Vector2()
export var speed = 1000
export var damage = 5

func _ready():
	add_to_group('bullet')
	set_physics_process(true)
	
func start_at(rot, pos):
	rotation = rot
	position = pos
	vel = Vector2(speed, 0).rotated(rot - PI / 2)
	
func _physics_process(delta):
	position += vel * delta

func _on_Lifetime_timeout():
	queue_free()


func _on_AstBullet_body_shape_entered(body_id, body, body_shape, area_shape):
	if (body.is_in_group("asteroid")):
		body.call_deferred("hit_by_bullet", position)
		queue_free()
