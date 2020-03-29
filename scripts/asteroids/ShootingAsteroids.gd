extends Node

signal bullet_hit_asteroid(hit_position)
export (PackedScene) var asteroid


func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton:
		spawn_asteroid(event.position)


func spawn_asteroid(coordinate_vector):
	if $asteroidSpawn.is_stopped():
		var ast = asteroid.instance()
		ast.position = coordinate_vector
		add_child(ast)
		$asteroidSpawn.start()
