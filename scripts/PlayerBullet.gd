extends Area2D

var vel = Vector2()
export var speed = 1000

func _ready():
	set_physics_process(true)
	
func start_at(rot, pos):
	rotation = rot
	position = pos
	vel = Vector2(speed, 0).rotated(rot - PI / 2)
	
func _physics_process(delta):
	position += vel * delta


func _on_Lifetime_timeout():
	queue_free()
