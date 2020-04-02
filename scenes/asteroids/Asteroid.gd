class_name Asteroid	
extends RigidBody2D

export (PackedScene) var hit_effect
onready var screensize := get_viewport().get_visible_rect().size
var asteroid_scene = load("res://scenes/asteroids/Asteroid.tscn")
onready var decoupler_node = Node.new()
var is_ghost: bool
var ghost_promoted: bool
var ghost_wrap_direction
var ghost

enum GHOST_SPAWN_EDGE {
	TOP,
	LEFT,
	RIGHT,
	BOTTOM
}

enum WRAP_ORIENTATION {
    VERTICAL,
    HORIZONTAL
}

func _ready():
	add_to_group('asteroid')
	get_tree().get_root().get_node("Main/ScreenWrapperAreas/VerticalWrapArea").connect("body_entered", self, "_on_VerticalWrapArea_body_entered")
	get_tree().get_root().get_node("Main/ScreenWrapperAreas/HorizontalWrapArea").connect("body_entered", self, "_on_HorizontalWrapArea_body_entered")
	get_tree().get_root().get_node("Main/ScreenWrapperAreas/PlayArea").connect("body_exited", self, "_on_PlayArea_body_exited")


func hit_by_bullet(position, rotation, _damage):
	var hit_fx = hit_effect.instance()
	hit_fx.position = position
	hit_fx.rotation = rotation
	self.get_parent().add_child(hit_fx)


func wrap_direction_from_transform(transform):
	var horizontal_middle_of_screen = screensize.x / 2
	var vertical_middle_of_screen = screensize.y / 2
	match ghost_wrap_direction:
		WRAP_ORIENTATION.VERTICAL:
			if transform.origin.y >= vertical_middle_of_screen:
				return GHOST_SPAWN_EDGE.TOP
			elif transform.origin.y < vertical_middle_of_screen:
				return GHOST_SPAWN_EDGE.BOTTOM
		WRAP_ORIENTATION.HORIZONTAL:
			if transform.origin.x >= horizontal_middle_of_screen:
				return GHOST_SPAWN_EDGE.RIGHT
			elif transform.origin.x < horizontal_middle_of_screen:
				return GHOST_SPAWN_EDGE.LEFT

func ghost_transform_from_parent(parent_transform):
	var ghost_transform = parent_transform
	match wrap_direction_from_transform(parent_transform):
		GHOST_SPAWN_EDGE.TOP:
			ghost_transform.origin.y = parent_transform.origin.y - screensize.y
		GHOST_SPAWN_EDGE.BOTTOM:
			ghost_transform.origin.y = parent_transform.origin.y + screensize.y
		GHOST_SPAWN_EDGE.LEFT:
			ghost_transform.origin.x = parent_transform.origin.x + screensize.x
		GHOST_SPAWN_EDGE.RIGHT:
			ghost_transform.origin.x = parent_transform.origin.x - screensize.x
	return ghost_transform 
	

func _integrate_forces(state):
	if is_ghost:
		var original_asteroid = get_parent().get_parent()
		state.set_transform(ghost_transform_from_parent(original_asteroid.get_transform()))
		state.linear_velocity = original_asteroid.linear_velocity
		state.angular_velocity = original_asteroid.angular_velocity


func spawn_ghost(wrap_orientation):
	ghost = asteroid_scene.instance()
	ghost.is_ghost = true
	ghost.position = position + screensize + screensize # spawns off screen for 1 frame before physics take over
	ghost.ghost_wrap_direction = wrap_orientation
	decoupler_node.add_child(ghost)
	add_child(decoupler_node)
	

func _on_VerticalWrapArea_body_entered(body):
	if body.is_in_group("asteroid") && !body.is_ghost && !body.ghost:
		body.call_deferred("spawn_ghost", WRAP_ORIENTATION.VERTICAL)


func _on_HorizontalWrapArea_body_entered(body):
	if body.is_in_group("asteroid") && !body.is_ghost && !body.ghost:
		body.call_deferred("spawn_ghost", WRAP_ORIENTATION.HORIZONTAL)


func promote_ghost():
	if !ghost_promoted && ghost:
		var parent = get_parent()
		decoupler_node.remove_child(ghost)
		ghost.is_ghost = false
		parent.add_child(ghost)
		ghost_promoted = true


func _on_PlayArea_body_exited(body):
	if body.is_in_group("asteroid") && !body.is_ghost:
		body.call_deferred("promote_ghost")
		body.queue_free()
