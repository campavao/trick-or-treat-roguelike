extends TextureButton

var player_ref: Player

func _process(_delta):
	if player_ref:
		$HealthBar.value = player_ref.health
		$HealthBarLabel.text = str(player_ref.health) + " / " + str(player_ref.starting_health)
		$ProtectionAmount.text = str(player_ref.protection)

		if player_ref.protection > 0:
			$ProtectionIcon.show()
			$ProtectionAmount.show()
		else:
			$ProtectionIcon.hide()
			$ProtectionAmount.hide()

func init(player: Player):
	player_ref = player

	match player.character:
		Shared.Characters.WARRIOR:
			texture_normal = preload("res://art/warrior.png")

		Shared.Characters.WIZARD:
			texture_normal = preload("res://art/wizard.png")

		Shared.Characters.WITCH:
			texture_normal = preload("res://art/witch.png")
