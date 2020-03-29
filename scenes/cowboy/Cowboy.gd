extends RigidBody2D

export var rotation_speed := 50
export var bullet_force := 500

func turn_left(delta: float):
	#rotation -= rotation_speed * delta
	apply_torque_impulse(-rotation_speed)


func turn_right(delta: float):
	#rotation += rotation_speed * delta
	apply_torque_impulse(rotation_speed)
	
func shoot():
	if !$AnimatedSprite.is_playing():
		var shot_impulse = -Vector2(bullet_force, 0).rotated(rotation)
		apply_central_impulse(shot_impulse)
		$AnimatedSprite.animation = "shoot"
		$AnimatedSprite.play()

func thrust(_delta):
	pass

func _physics_process(delta):
	$Node.process_check_input(delta, self)

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.animation = "idle"
