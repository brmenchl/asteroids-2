extends Node

export (PackedScene) var bullet

var screen_size = Vector2()

func _ready():
	screen_size = get_viewport().size
	$HUD.init_with_players([$Player])

func _on_BulletTimer_timeout():
	var b = bullet.instance()
	add_child(b)
	b.start_at(0, Vector2(screen_size.x / 2, screen_size.y))
