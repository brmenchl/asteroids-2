extends Area2D

signal started_reeling(body)
signal broke_connection

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
		emit_signal("started_reeling", body)
	elif body is Asteroid:
		emit_signal("broke_connection")
		queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
