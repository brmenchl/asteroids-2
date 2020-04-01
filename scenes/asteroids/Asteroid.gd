class_name Asteroid
extends RigidBody2D

export (PackedScene) var hit_effect
onready var screensize := get_viewport().get_visible_rect().size
var asteroid_scene = load("res://scenes/asteroids/Asteroid.tscn")
var decoupler_node: Node
var is_ghost: bool
var ghost_promoted: bool
var ghost


func _ready():
	add_to_group('asteroid')
	decoupler_node = Node.new()
	get_tree().get_root().get_node("Main/ScreenWrapperAreas/WrapArea").connect("body_entered", self, "_on_WrapArea_body_entered", [], Object.CONNECT_ONESHOT)
	get_tree().get_root().get_node("Main/ScreenWrapperAreas/PlayArea").connect("body_exited", self, "_on_PlayArea_body_exited", [], Object.CONNECT_ONESHOT)


func hit_by_bullet(position, rotation, _damage):
	var hit_fx = hit_effect.instance()
	hit_fx.position = position
	hit_fx.rotation = rotation
	self.get_parent().add_child(hit_fx)


func _integrate_forces(state):
	if is_ghost:
		var original_asteroid = get_parent().get_parent()
		var ghost_transform = original_asteroid.get_transform()
		ghost_transform.origin.y = original_asteroid.get_transform().origin.y + screensize.y
		state.set_transform(ghost_transform)
		state.linear_velocity = original_asteroid.linear_velocity
		state.angular_velocity = original_asteroid.angular_velocity


func spawn_ghost():
	ghost = asteroid_scene.instance()
	ghost.is_ghost = true
	ghost.position = position + screensize
	ghost.name = get_name() + "-jr"
	decoupler_node.add_child(ghost)
	add_child(decoupler_node)
	


func _on_WrapArea_body_entered(body):
	if body.is_in_group("asteroid") && !body.ghost:
		print(body.get_name() + " is going to spawn " + body.get_name() + "-jr")
		body.call_deferred("spawn_ghost")


func promote_ghost():
	if !ghost_promoted && ghost:
		var parent = get_parent()
		decoupler_node.remove_child(ghost)
		ghost.is_ghost = false
		parent.add_child(ghost)
		ghost_promoted = true
		print("promoted!")


func _on_PlayArea_body_exited(body):
	# promote ghost to be a sibling
	if body.is_in_group("asteroid") && !body.is_ghost:
		print(body.get_name() + " is going to promote " + body.ghost.get_name())
		body.call_deferred("promote_ghost")
		body.queue_free()
