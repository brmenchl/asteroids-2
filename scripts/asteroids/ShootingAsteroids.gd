extends Node

export (PackedScene) var asteroid
signal bullet_hit_asteroid(hit_position)

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _input(event):
   # Mouse in viewport coordinates
   if event is InputEventMouseButton:
	   spawn_asteroid(event.position)

func spawn_asteroid(coordinate_vector):
	if($asteroidSpawn.is_stopped()):
		var ast = asteroid.instance()
		ast.position = coordinate_vector
		add_child(ast)
		$asteroidSpawn.start()
