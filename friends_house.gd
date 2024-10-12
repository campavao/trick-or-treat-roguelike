extends Node2D

signal complete()

var player_ref: Player

var is_upgrading: bool

func enable(player: Player):
	show()
	player_ref = player


func _on_button_pressed() -> void:
	reset()

func populate_inventory():
	for candy in player_ref.basket:
		# Don't allow upgrading max level candy
		if is_upgrading and candy.level == Shared.CandyLevel.PARTY_SIZE:
			return
			
		var texture = Shared.get_candy_texture(candy.texture_path)
		var index = $Inventory.add_item(candy.name, texture, true)
		$Inventory.set_item_tooltip(index, Shared.get_candy_tooltip(candy))
		$Inventory.set_item_tooltip_enabled(index, true)
	
	$Inventory.show()

func _on_inventory_item_selected(index: int) -> void:
	if is_upgrading:
		var candy = player_ref.basket[index]
		candy.level_up()
	else:
		player_ref.basket.remove_at(index)
	reset()

func reset():
	hide()
	complete.emit()
	$Inventory.clear()
	$Inventory.hide()
	$RemoveButton.show()
	$UpgradeButton.show()


func _on_upgrade_button_pressed() -> void:
	is_upgrading = true
	hide_options()
	populate_inventory()
	
func _on_remove_button_pressed() -> void:
	is_upgrading = false
	hide_options()
	populate_inventory()
	
func hide_options():
	$RemoveButton.hide()
	$UpgradeButton.hide()
