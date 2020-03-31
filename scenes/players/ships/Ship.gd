class_name Ship
extends RigidBody2D

signal health_changed(new_value)

export (int) var engine_thrust = 800
export (int) var spin_thrust = 5000
export (int) var max_speed = 280
export (int) var health = 100
export (float) var fire_rate = 0.3

var fire_rate_timer: Timer = null
onready var texture = ($Sprite as Sprite).texture

const bullet = preload("res://scenes/players/bullets/Bullet.tscn")

func _get_configuration_warning() -> String:
	if $ScreenWrappable == null:
		return "Must have a ScreenWrappable child"
	return ""


func _ready():
	add_to_group("ship")
	fire_rate_timer = Timer.new()
	fire_rate_timer.one_shot = true
	fire_rate_timer.wait_time = fire_rate
	add_child(fire_rate_timer)


func move(directions):
	var rotation_dir := -int(directions.left) + int(directions.right)
	apply_torque_impulse(rotation_dir * spin_thrust)
	var thrust_direction := -int(directions.thrust) + int(directions.reverse_thrust)
	apply_central_impulse(Vector2(0, engine_thrust * thrust_direction).rotated(rotation))
	var fire_thruster_map := {
		"forward": directions.thrust,
		"reverse": directions.reverse_thrust,
		"port": directions.right,  # fires opposite thruster
		"starboard": directions.left,  # fires opposite thruster
	}
	fire_thrusters(fire_thruster_map)


func _integrate_forces(state):
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
	var transformation: Transform2D = $ScreenWrappable.screen_wrapped_transformation(
		state.get_transform()
	)
	state.set_transform(transformation)


func fire_thrusters(fire_thruster_map):
	var particle_to_thruster_map := {
		"forward": $ThrusterParticles/ForwardThrusterParticle,
		"reverse": $ThrusterParticles/ReverseThrusterParticle,
		"port": $ThrusterParticles/PortThrusterParticle,
		"starboard": $ThrusterParticles/StarboardThrusterParticle,
	}
	for thruster in fire_thruster_map:
		particle_to_thruster_map.get(thruster).emitting = fire_thruster_map.get(thruster)


func shoot():
	if fire_rate_timer.is_stopped():
		fire_rate_timer.start()
		var b = bullet.instance()
		$BulletContainer.add_child(b)
		b.start_at(rotation, $BulletSpawnPoint.global_position)


func hit_by_bullet(position: float, rotation: float, damage: int):
	health = clamp(health - damage, 0, 100)
	emit_signal('health_changed', health)

	var fx = EmittableHullDamageFx.instance()
	fx.position = position
	fx.rotation = rotation
	get_parent().add_child(fx)

	if health == 0:
		queue_free()
