extends Node
# this class is a "Controllers" singleton that micro-manages the existence of controllers
# based on the number of connected players

var controller_count = 1


func create_controller():
	var controller = Controller.new()
	controller.add_to_group("controllers")
	controller.name = "player%d" % controller_count
	controller_count += 1
	add_child(controller)
	return controller
