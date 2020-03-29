extends MarginContainer

const PLAYER_STATS = preload("res://scenes/gui/PlayerStats.tscn")


func init_with_players(players: Array):
	for player in players:
		var stats = PLAYER_STATS.instance()
		$PlayerStatsRow.add_child(stats)
		stats.init_with_player(player as Player)
