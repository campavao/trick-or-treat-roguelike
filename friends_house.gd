extends Node2D

signal complete()

var player_ref: Player

func enable(player: Player):
	show()

	self.player_ref = player

	for candy in player.basket:
		var texture = Shared.get_candy_texture(candy.texture_path)
		var index = $Inventory.add_item(candy.name, texture, true)
		$Inventory.set_item_tooltip(index, Shared.get_candy_tooltip(candy))
		$Inventory.set_item_tooltip_enabled(index, true)

func _on_button_pressed() -> void:
	reset()


func _on_inventory_item_selected(index: int) -> void:
	var candy = player_ref.basket[index]
	candy.level_up()
	reset()

func reset():
	hide()
	complete.emit()
	$Inventory.clear()
