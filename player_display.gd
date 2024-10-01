extends Node2D

var player_ref: Player

func _process(_delta):
	if player_ref:
		$HealthBar.value = player_ref.health

func init(player: Player):
	player_ref = player
	
	match player.character:
		Shared.Characters.WARRIOR:
			$Sprite2D.texture = preload("res://art/warrior.png")

		Shared.Characters.WIZARD:
			$Sprite2D.texture = preload("res://art/wizard.png")

		Shared.Characters.WITCH:
			$Sprite2D.texture = preload("res://art/witch.png")
