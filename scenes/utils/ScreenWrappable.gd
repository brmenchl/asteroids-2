extends Node

onready var screen_size := get_viewport().get_visible_rect().size


func screen_wrapped_transformation(transform2d: Transform2D) -> Transform2D:
	var new_transformation_matrix := transform2d
	if new_transformation_matrix.origin.x > screen_size.x:
		new_transformation_matrix.origin.x = 0
	if new_transformation_matrix.origin.x < 0:
		new_transformation_matrix.origin.x = screen_size.x
	if new_transformation_matrix.origin.y > screen_size.y:
		new_transformation_matrix.origin.y = 0
	if new_transformation_matrix.origin.y < 0:
		new_transformation_matrix.origin.y = screen_size.y
	return new_transformation_matrix
