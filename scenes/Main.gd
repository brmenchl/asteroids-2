extends Node


func _ready():
	$HUD.init_with_players([$Players/Player1, $Players/Player2])

func _process(delta: float) -> void:
	if OS.is_debug_build() and Input.is_action_pressed("debug_quit"):
		get_tree().quit()
