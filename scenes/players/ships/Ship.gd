class_name Ship
extends RigidBody2D

signal health_changed(new_value)

export var rot_speed = 2.6
export var thrust = 500
export var max_velocity = 400
export var playerIdx = ''
export (PackedScene) var bullet
export (PackedScene) var emittableHullDamageFx

var rot = 0
var vel = Vector2()
var health = 100
onready var texture = ($Sprite as Sprite).texture

func _ready():
	add_to_group("ship")

func _process(delta):
	var fire_thruster_map = {
		"forward": false,
		"reverse": false,
		"port": false,
		"starboard": false,
	}
	var player_name = "player" + playerIdx
	if Input.is_action_pressed(player_name + "_shoot"):
		shoot()
	
	if Input.is_action_pressed(player_name + "_left"):
		rot -= rot_speed * delta
		fire_thruster_map["starboard"] = true # fires opposite thruster
	if Input.is_action_pressed(player_name + "_right"):
		rot += rot_speed * delta
		fire_thruster_map["port"] = true # fires opposite thruster

	rotation = rot
	var thrust_direction = 0
	if Input.is_action_pressed(player_name + "_thrust"):
		thrust_direction = 1
		fire_thruster_map["forward"] = true
	elif Input.is_action_pressed(player_name + "_reverse_thrust"):
		thrust_direction = -1
		fire_thruster_map["reverse"] = true
	var acc = get_acceleration(thrust_direction)
	vel += acc * delta
	position = position + vel * delta
	fire_thrusters(fire_thruster_map)

func get_acceleration(thrust_direction: int):
	var friction_force = vel * friction
	var applied_thrust = thrust * thrust_direction
	return Vector2(applied_thrust, 0).rotated(rotation - PI / 2) - friction_force

func fire_thrusters(fire_thruster_map: Dictionary):
	var particle_to_thruster_map = {
		"forward": $ThrusterParticles/ForwardThrusterParticle,
		"reverse": $ThrusterParticles/ReverseThrusterParticle,
		"port": $ThrusterParticles/PortThrusterParticle,
		"starboard": $ThrusterParticles/StarboardThrusterParticle,
	}
	for thruster in fire_thruster_map:
		particle_to_thruster_map.get(thruster).emitting = fire_thruster_map.get(thruster)

func shoot():
	if $FireRate.is_stopped():
		$FireRate.start()
		var b = bullet.instance()

		$BulletContainer.add_child(b)
		b.start_at(rotation, $BulletSpawnPoint.global_position)

func hit_by_bullet(position, rotation, damage):
	health = clamp(health - damage, 0, 100)
	emit_signal('health_changed', health)
	
	var fx = emittableHullDamageFx.instance()
	fx.position = position
	fx.rotation = rotation
	self.get_parent().add_child(fx)
	
	if health == 0:
		queue_free()
