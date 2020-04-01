extends Area2D

export var speed = 750
var vel = Vector2()


func start_at(rot, pos):
	rotation = rot
	position = pos
	vel = Vector2(speed, 0).rotated(rot)


func _physics_process(delta):
	position += vel * delta


func _on_LassoTip_body_entered(body: Node) -> void:
	if body.is_in_group("ship"):
		print("REEL IN")
	elif body is Asteroid:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
