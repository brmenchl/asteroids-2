# Because you don't have multiple inheritance or traits in GDScript
# you need an intermediate node that understands how to fetch and work with
# the Controllers singleton and provide access to a target for the individual
# controller
extends Node

var controller: Node = null


func _init():
	# This is only needed to guarantee that there is a Controller for each
	# player that exists outside of the main scene.
	controller = Controllers.create_controller()


func _notification(p_what: int) -> void:
	match p_what:
		# This ensures that the "target" exists even if a node hierarchy is built
		# outside of the SceneTree
		NOTIFICATION_PARENTED:
			if not controller.target:
				controller.target = get_parent()
