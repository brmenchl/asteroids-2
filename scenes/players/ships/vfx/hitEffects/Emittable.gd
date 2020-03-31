extends Node2D


func _ready():
	emit()


func emit():
	for particle in get_children():
		particle.emitting = true
