class_name Cowboy
extends RigidBody2D

export var spin_thrust = 100
export var max_speed = 280
export var bullet_force := 500
export var shots_per_second := 3


func _ready():
	$AnimatedSprite.speed_scale = shots_per_second * 4


func move(directions):
	var rotation_dir := -int(directions.left) + int(directions.right)
	apply_torque_impulse(rotation_dir * spin_thrust)


func shoot():
	if ! $AnimatedSprite.is_playing():
		var shot_impulse = -Vector2(bullet_force, 0).rotated(rotation)
		apply_central_impulse(shot_impulse)
		$AnimatedSprite.animation = "shoot"
		$AnimatedSprite.play()
		yield($AnimatedSprite, 'animation_finished')
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = "idle"


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var transformation = $ScreenWrappable.screen_wrapped_transformation(state.get_transform())
	state.set_transform(transformation)
