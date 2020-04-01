class_name Cowboy
extends RigidBody2D

const LASSO = preload("res://scenes/cowboy/Lasso.tscn")

export var spin_thrust := 100
export var max_speed := 280
export var bullet_force := 500
export var shots_per_second := 3
export var eject_force := 300
export var reel_force := 500
var control_enabled := false
var is_ejected := false
var eject_timer = Timer.new()
var lasso_extended := false
var lasso = null
var is_reeling := false
var reel_target = null


func _ready():
	randomize()
	$AnimatedSprite.speed_scale = shots_per_second * 4
	eject_timer.wait_time = 0.5
	eject_timer.one_shot = true
	add_child(eject_timer)


func move(directions):
	var rotation_dir := -int(directions.left) + int(directions.right)
	apply_torque_impulse(rotation_dir * spin_thrust)


func shoot():
	if ! $AnimatedSprite.is_playing() and ! is_reeling:
		var shot_impulse = -Vector2(bullet_force, 0).rotated(rotation)
		apply_central_impulse(shot_impulse)
		$AnimatedSprite.animation = "shoot"
		$AnimatedSprite.play()
		yield($AnimatedSprite, 'animation_finished')
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = "idle"


func secondary():
	if control_enabled and ! lasso_extended:
		lasso = LASSO.instance()
		get_parent().add_child(lasso)
		lasso.start_at(rotation, global_position)
		lasso_extended = true
		lasso.connect("broke_connection", self, "reset_lasso")
		lasso.connect("tree_exited", self, "reset_if_not_reeling")
		lasso.connect("started_reeling", self, "start_reeling")


func reset_lasso():
	lasso = null
	lasso_extended = false
	is_reeling = false
	reel_target = null

func reset_if_not_reeling():
	if ! is_reeling:
		reset_lasso()

func start_reeling(body):
	is_reeling = true
	reel_target = body

func eject(direction = rand_range(0, 2 * PI)):
	if ! is_ejected:
		var eject_impulse = Vector2(eject_force, 0).rotated(direction)
		apply_central_impulse(eject_impulse)
		visible = true
		is_ejected = true
		eject_timer.start()
		yield(eject_timer, "timeout")
		control_enabled = true


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if is_reeling:
		var direction = ( reel_target.position - position ).normalized()
		state.set_linear_velocity(Vector2(reel_force, 0).rotated(direction.angle()))
	var transformation = $ScreenWrappable.screen_wrapped_transformation(state.get_transform())
	state.set_transform(transformation)


func _on_Cowboy_body_entered(body) -> void:
	if is_reeling:
		reset_lasso()
		if body.is_in_group("ship"):
			if body.is_occupied():
				print("EJJECT")
				body.call_deferred('eject_cowboy')
				yield(body, "cowboy_ejected")
			var pawn = $Pawn
			remove_child(pawn)
			body.add_child(pawn)
			queue_free()
