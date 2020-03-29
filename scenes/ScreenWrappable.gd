extends Node2D

onready var screen_size = get_viewport_rect().size

func _process(delta):
	for N in get_children():
		N.position = wrap_screen_edges(N.position)

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
