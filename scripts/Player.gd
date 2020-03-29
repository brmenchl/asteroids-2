extends Area2D
class_name Player

export var rot_speed = 2.6
export var thrust = 500
export var max_velocity = 400
export var friction = 0.65
export (PackedScene) var bullet

var screen_size
var rot = 0
var vel = Vector2()
var health = 100
var texture = preload("res://tempAssets/sheet.playerShip1_red.atlastex")

signal health_changed(new_value)

func _ready():
	screen_size = get_viewport_rect().size
	position = screen_size / 2
	($Ship as Sprite).texture = texture;

func _process(delta):
	if Input.is_action_pressed("player_shoot"):
		shoot()
		
	if Input.is_action_pressed("player_left"):
		rot -= rot_speed * delta
	if Input.is_action_pressed("player_right"):
		rot += rot_speed * delta
	
	rotation = rot
	
	var acc = get_acceleration(Input.is_action_pressed("player_thrust"))
	vel += acc * delta
	position = wrap_screen_edges(position + vel * delta)

func get_acceleration(isThrusting):
	var friction_force = vel * friction
	var applied_thrust
	
	if isThrusting:
		applied_thrust = thrust;
	else:
		applied_thrust = 0;
	
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
	if($FireRate.is_stopped()):
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
