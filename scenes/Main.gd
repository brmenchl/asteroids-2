extends Node


func _ready():
	$HUD.init_with_players([$Players/Player1, $Players/Player2])
