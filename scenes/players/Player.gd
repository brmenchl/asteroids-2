class_name Player
extends Area2D

signal health_changed(new_value)

export var rot_speed = 2.6
export var thrust = 500
export var max_velocity = 400
export var friction = 0.65
export var playerIdx = ''
export (PackedScene) var bullet

var rot = 0
var vel = Vector2()
var health = 100
onready var screen_size = get_viewport_rect().size
onready var texture = ($Ship as Sprite).texture


func _process(delta):
	var player_name = "player" + playerIdx
	if Input.is_action_pressed(player_name + "_shoot"):
		shoot()

	if Input.is_action_pressed(player_name + "_left"):
		rot -= rot_speed * delta
	if Input.is_action_pressed(player_name + "_right"):
		rot += rot_speed * delta

	rotation = rot
	var thrust_direction = 0
	if Input.is_action_pressed(player_name + "_thrust"):
		thrust_direction = 1
	elif Input.is_action_pressed(player_name + "_reverse_thrust"):
		thrust_direction = -1
	var acc = get_acceleration(thrust_direction)
	vel += acc * delta
	position = wrap_screen_edges(position + vel * delta)

func get_acceleration(thrust_direction: int):
	var friction_force = vel * friction
	var applied_thrust = thrust * thrust_direction
	return Vector2(applied_thrust, 0).rotated(rotation - PI / 2) - friction_force


func wrap_screen_edges(pos):
	var new_pos = pos
	if pos.x > screen_size.x:
		new_pos.x = 0
	if pos.x < 0:
		new_pos.x = screen_size.x
	if pos.y > screen_size.y:
		new_pos.y = 0
	if pos.y < 0:
		new_pos.y = screen_size.y
	return new_pos


func shoot():
	if $FireRate.is_stopped():
		$FireRate.start()
		var b = bullet.instance()

		$BulletContainer.add_child(b)
		b.start_at(rotation, $BulletSpawnPoint.global_position)


func _on_Player_area_entered(area):
	if area.get_groups().has('bullet'):
		apply_damage(area.damage)
		area.queue_free()


func apply_damage(damage):
	health = clamp(health - damage, 0, 100)
	emit_signal('health_changed', health)
	if health == 0:
		queue_free()
