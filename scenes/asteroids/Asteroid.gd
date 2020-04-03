class_name Asteroid	
extends RigidBody2D

export (PackedScene) var hit_effect
onready var screensize := get_viewport().get_visible_rect().size

func _ready():
	var new_sprite = $Sprite.duplicate(Node.DUPLICATE_USE_INSTANCING)
	new_sprite.position.x = position.x + 500
	var new_collision = $CollisionPolygon2D.duplicate(DUPLICATE_USE_INSTANCING)
	new_collision.position.x = position.x + 500
	add_child(new_sprite)
	add_child(new_collision)
	
func _process(delta):
	var rotation_per_frame = delta / 5
	$Sprite.rotation += rotation_per_frame
	$CollisionPolygon2D.rotation += rotation_per_frame

func hit_by_bullet(position, rotation, _damage):
	var hit_fx = hit_effect.instance()
	hit_fx.position = position
	hit_fx.rotation = rotation
	self.get_parent().add_child(hit_fx)

func _integrate_forces(state):
	state.angular_velocity = 0

