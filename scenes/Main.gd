extends Node


func _ready():
	$HUD.init_with_players([$ScreenWrappable/Player1, $ScreenWrappable/Player2])
