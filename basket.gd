extends Node2D

signal on_candy_select(candy_index: int)

@export var player: Player
		
func reset_basket():
	$CandyList.clear()

func populate_from_basket(is_active: bool = false):
	for candy in player.basket:
		var texture = Shared.get_candy_texture(candy)
		var index = $CandyList.add_item(candy.name, texture, is_active)
		$CandyList.set_item_tooltip(index, Shared.get_candy_tooltip(candy))
		$CandyList.set_item_tooltip_enabled(index, true)
		
func open_basket(is_active: bool):
	populate_from_basket(is_active)

func _on_candy_list_item_selected(index: int) -> void:
	on_candy_select.emit(index)

func _on_view_basket_button_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$CandyList.hide()
		reset_basket()
		$ViewBasketButton.text = "View Basket"
	else:
		populate_from_basket()
		$CandyList.show()
		$ViewBasketButton.text = "Close"
