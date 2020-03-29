extends Node

func _ready():
	$HUD.init_with_players([$Player1, $Player2])
