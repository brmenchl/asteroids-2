class_name Asteroid	
extends Node2D

export (PackedScene) var hit_effect
onready var screensize := get_viewport().get_visible_rect().size
var clones_by_section_id = {}
var screenwrap_clone_offsets = {}

signal swap_visible_asteroid

func new_instance(position_offset: Vector2):
	var new_sprite = $Asteroid/AsteroidSprite.duplicate(DUPLICATE_USE_INSTANCING)
	var new_collision = $Asteroid/AsteroidCollision.duplicate(DUPLICATE_USE_INSTANCING)
	new_sprite.position += position_offset
	new_collision.position += position_offset
	return {
		"sprite": new_sprite,
		"collision": new_collision
	}

func _ready():
	# screenwrap offset sections:
	# 0 |     1    | 2
	# 7 | playarea | 3
	# 6 |     5    | 4
	
	screenwrap_clone_offsets = {
		0: Vector2(-1 * screensize.x, -1 * screensize.y),
		1: Vector2(0, -1 * screensize.y), # 1
		2: Vector2(screensize.x, -1 * screensize.y), # 2
		3: Vector2(screensize.x, 0), # 3
		4: Vector2(screensize.x, screensize.y), # 4
		5: Vector2(0, screensize.y), # 5
		6: Vector2(-1 * screensize.x, screensize.y), # 6
		7: Vector2(-1 * screensize.x, 0), # 7
	}
	
	for section_id in range(screenwrap_clone_offsets.size()):
		var clone = new_instance(screenwrap_clone_offsets[section_id])
		$Asteroid.add_child(clone.sprite)
		$Asteroid.add_child(clone.collision)
		clones_by_section_id[section_id] = clone
	
func _process(delta):
	if is_visible_asteroid_off_screen():
		emit_signal("swap_visible_asteroid")
	
	var rotation_per_frame = delta / 5
	for node in $Asteroid.get_children():
		node.rotation += rotation_per_frame

func hit_by_bullet(position, rotation, _damage):
	var hit_fx = hit_effect.instance()
	hit_fx.position = position
	hit_fx.rotation = rotation
	self.get_parent().add_child(hit_fx)

func visible_asteroid_position():
	return get_global_transform().origin + $Asteroid.position

func is_visible_asteroid_off_screen():
	var visible_asteroid_bounds = $VisibleAsteroidArea/CollisionShape2D.shape.extents
	var visible_asteroid_pos = visible_asteroid_position()
	var visible_corners = {}
	visible_corners.upper_left = visible_asteroid_pos - visible_asteroid_bounds
	visible_corners.lower_right = visible_asteroid_pos + visible_asteroid_bounds
	return (
		visible_corners.upper_left.x > screensize.x || 
		visible_corners.upper_left.y > screensize.y || 
		visible_corners.lower_right.x < 0 ||
		visible_corners.lower_right.y < 0
	)

func clone_section_id_from_position(position: Vector2):
	return 6
	
func _on_swap_visible_asteroid():
	var ex_visible_asteroids_new_section_id = clone_section_id_from_position(visible_asteroid_position())
	# get this number's asteroid stuffs
	# visible asteroid's stuffs is now assigned to this number
	# change visible asteroid shape info to opposite asteroid
	# number 6 is now moved to opposite asteroid's offset position
	# number 6 is now assigned to opposite's place, which is 2
	connect("swap_visible_asteroid", self, "_on_swap_visible_asteroid", [], CONNECT_ONESHOT)

func _integrate_forces(state):
	state.angular_velocity = 0

func _on_PlayArea_body_exited(body):
	if body.is_in_group("visible_asteroid_collision"):
		print("yes!")
