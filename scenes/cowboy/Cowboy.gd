extends RigidBody2D

class_name Cowboy

export var spin_thrust = 100
export var max_speed = 280
export var playerIdx = ''
export var bullet_force := 500
export var shots_per_second := 3
var player_name = "player" + playerIdx
var rotation_dir = 0

func _ready():
	$AnimatedSprite.speed_scale = shots_per_second * 4

func process_input():
	if Input.is_action_pressed(player_name + "_shoot"):
		shoot()
	
	rotation_dir = 0
	if Input.is_action_pressed(player_name + "_left"):
		rotation_dir -= 1
	if Input.is_action_pressed(player_name + "_right"):
		rotation_dir += 1

func _process(_delta):
	process_input()

func _physics_process(_delta):
	apply_torque_impulse(rotation_dir * spin_thrust)

func _integrate_forces(state):
	if state.linear_velocity.length()>max_speed:
		state.linear_velocity=state.linear_velocity.normalized()*max_speed

func shoot():
	if !$AnimatedSprite.is_playing():
		var shot_impulse = -Vector2(bullet_force, 0).rotated(rotation)
		apply_central_impulse(shot_impulse)
		$AnimatedSprite.animation = "shoot"
		$AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.animation = "idle"
