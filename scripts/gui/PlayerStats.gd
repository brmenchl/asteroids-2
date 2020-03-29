extends HBoxContainer

onready var health_label: Label = $MarginContainer/Background/Health
onready var player_image: TextureRect = $MarginContainer/Background/Image

func init_with_player(player: Player):
	update_health(player.health)
	player_image.texture = player.texture
	var err = player.connect("health_changed", self, "update_health")
	if err != OK:
		print("Error", err)

func update_health(new_value: int):
	health_label.text = str(new_value)
