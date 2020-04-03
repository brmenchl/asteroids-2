class_name Asteroid	
extends RigidBody2D

export (PackedScene) var hit_effect
onready var screensize := get_viewport().get_visible_rect().size

func add_new_instance(position_offset: Vector2):
	var new_sprite = $AsteroidSprite.duplicate(DUPLICATE_USE_INSTANCING)
	var new_collision = $AsteroidCollision.duplicate(DUPLICATE_USE_INSTANCING)
	new_sprite.position += position_offset
	new_collision.position += position_offset
	add_child(new_sprite)
	add_child(new_collision)

func _ready():
	# screenwrap offset sections:
	# 0 |     1    | 2
	# 7 | playarea | 3
	# 6 |     5    | 4
	
	var screenwrap_clone_offsets = [
		Vector2(-1 * screensize.x, -1 * screensize.y), # 0
		Vector2(0, -1 * screensize.y), # 1
		Vector2(screensize.x, -1 * screensize.y), # 2
		Vector2(screensize.x, 0), # 3
		Vector2(screensize.x, screensize.y), # 4
		Vector2(0, screensize.y), # 5
		Vector2(-1 * screensize.x, screensize.y), # 6
		Vector2(-1 * screensize.x, 0), # 7
	]
	
	for offset in screenwrap_clone_offsets:
		add_new_instance(offset)
	
func _process(delta):
	var rotation_per_frame = delta / 5
	for node in get_children():
		node.rotation += rotation_per_frame

func hit_by_bullet(position, rotation, _damage):
	var hit_fx = hit_effect.instance()
	hit_fx.position = position
	hit_fx.rotation = rotation
	self.get_parent().add_child(hit_fx)

func _integrate_forces(state):
	state.angular_velocity = 0

