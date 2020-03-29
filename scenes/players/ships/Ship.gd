class_name Ship
extends RigidBody2D

signal health_changed(new_value)

export var rot_speed = 2.6
export var engine_thrust = 100
export var spin_thrust = 1500
export var max_speed = 400
export var playerIdx = ''
export var health = 100
export (PackedScene) var bullet
export (PackedScene) var emittableHullDamageFx

var thrust = Vector2()
var rotation_dir = 0

onready var texture = ($Sprite as Sprite).texture

func _ready():
	add_to_group("ship")

func process_input(player_name, fire_thruster_map):
	if Input.is_action_pressed(player_name + "_shoot"):
		shoot()
	
	rotation_dir = 0
	if Input.is_action_pressed(player_name + "_left"):
		rotation_dir -= 1
		fire_thruster_map["starboard"] = true # fires opposite thruster
	if Input.is_action_pressed(player_name + "_right"):
		rotation_dir += 1
		fire_thruster_map["port"] = true # fires opposite thruster
	
	var thrust_direction = 0
	if Input.is_action_pressed(player_name + "_thrust"):
		thrust_direction = -1
		fire_thruster_map["forward"] = true
	elif Input.is_action_pressed(player_name + "_reverse_thrust"):
		thrust_direction = 1
		fire_thruster_map["reverse"] = true
	thrust = Vector2(0, engine_thrust * thrust_direction)

func _process(delta):
	var fire_thruster_map = {
		"forward": false,
		"reverse": false,
		"port": false,
		"starboard": false,
	}
	var player_name = "player" + playerIdx
	process_input(player_name, fire_thruster_map)
	fire_thrusters(fire_thruster_map)

func _physics_process(delta):
	apply_central_impulse(thrust.rotated(rotation))
	apply_torque_impulse(rotation_dir * spin_thrust)
	
func _integrate_forces(state):
	if state.linear_velocity.length()>max_speed:
		state.linear_velocity=state.linear_velocity.normalized()*max_speed

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
