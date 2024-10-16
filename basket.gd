extends Node2D

@export var player: Player

var current_effect: Dictionary = {
	"type": Shared.TREAT_TYPES.NONE,
	"amount": 0
}
var side_effect: Dictionary = {
	"type": Shared.SIDE_EFFECTS.NONE,
	"amount": 0,
}

func reset_basket():
	$CandyList.clear()

func populate_from_basket():
	reset_basket()
	for candy in player.basket:
		var is_disabled_from_effect = current_effect.type == Shared.TREAT_TYPES.UPGRADE_CANDY and candy.level == Shared.CandyLevel.PARTY_SIZE
		var is_disabled_from_side_effect = side_effect.type == Shared.SIDE_EFFECTS.DOWNGRADE_CANDY and candy.level == Shared.CandyLevel.FUN_SIZE

		var is_disabled = is_disabled_from_effect or is_disabled_from_side_effect

		var texture = Shared.get_candy_texture(candy)
		var index = $CandyList.add_item(candy.name, texture, is_active())
		$CandyList.set_item_disabled(index, is_disabled)
		$CandyList.set_item_tooltip(index, Shared.get_candy_tooltip(candy))
		$CandyList.set_item_tooltip_enabled(index, true)

func _on_candy_list_item_selected(index: int) -> void:
	var selected_candy = player.basket[index]

	if current_effect.type != Shared.TREAT_TYPES.NONE and current_effect.amount > 0:
		match current_effect.type:
			Shared.TREAT_TYPES.UPGRADE_CANDY:
				selected_candy.level_up()
			Shared.TREAT_TYPES.DUPE_CANDY:
				var dupe_candy = Shared.get_candy(selected_candy.type, selected_candy.level)
				player.basket.push_back(dupe_candy)

		if current_effect.amount == 1:
			current_effect.type = Shared.TREAT_TYPES.NONE
			clear()

		current_effect.amount -= 1
		refresh()

		# Early return so we only call once per click
		return

	if side_effect.type != Shared.SIDE_EFFECTS.NONE and side_effect.amount > 0:
		match side_effect.type:
			Shared.SIDE_EFFECTS.REMOVE_CANDY:
				player.basket.remove_at(index)
			Shared.SIDE_EFFECTS.DOWNGRADE_CANDY:
				selected_candy.level_down()

		if side_effect.amount == 1:
			side_effect.type = Shared.SIDE_EFFECTS.NONE
			clear()

		side_effect.amount -= 1
		refresh()


func refresh():
	# Reset basket
	populate_from_basket()
	update_text()


	if not is_active():
		$ViewBasketButton.show()
		_on_view_basket_button_toggled(false)

func _on_view_basket_button_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		$CandyList.hide()
		reset_basket()
		$ViewBasketButton.text = "View Basket"
	else:
		populate_from_basket()
		$CandyList.show()
		$ViewBasketButton.text = "Close"

func trigger_effect(type: Shared.TREAT_TYPES, amount: int):
	$ViewBasketButton.hide()
	current_effect = {
		"type": type,
		"amount": amount
	}
	_on_view_basket_button_toggled(true)


func trigger_side_effect(type: Shared.SIDE_EFFECTS, amount: int):
	$ViewBasketButton.hide()
	side_effect = {
		"type": type,
		"amount": amount
	}
	_on_view_basket_button_toggled(true)


func _on_treat_downgrade_candy(amount: int) -> void:
	trigger_side_effect(Shared.SIDE_EFFECTS.DOWNGRADE_CANDY, amount)

func _on_treat_duplicate_candy(amount: int) -> void:
	trigger_effect(Shared.TREAT_TYPES.DUPE_CANDY, amount)

func _on_treat_remove_candy(amount: int) -> void:
	trigger_side_effect(Shared.SIDE_EFFECTS.REMOVE_CANDY, amount)

func _on_treat_upgrade_candy(amount: int) -> void:
	trigger_effect(Shared.TREAT_TYPES.UPGRADE_CANDY, amount)

func set_text(text: String):
	print("should be setting text to: ", text)
	$Label.text = text
	$Label.show()

func clear():
	$Label.text = ""
	$Label.hide()

func is_active():
	return current_effect.type != Shared.TREAT_TYPES.NONE or side_effect.type != Shared.SIDE_EFFECTS.NONE

func _process(_delta: float) -> void:
	if is_active():
		$ViewBasketButton.hide()

	if $Label.visible:
		return

	update_text()

func update_text():
	if current_effect.type != Shared.TREAT_TYPES.NONE:
		match current_effect.type:
			Shared.TREAT_TYPES.UPGRADE_CANDY:
				set_text(str(current_effect.amount).join(["Choose "," candy to upgrade"]))
				return
			Shared.TREAT_TYPES.DUPE_CANDY:
				set_text(str(current_effect.amount).join(["Choose "," candy to duplicate"]))
				return

	if side_effect.type != Shared.SIDE_EFFECTS.NONE:
		match side_effect.type:
			Shared.SIDE_EFFECTS.REMOVE_CANDY:
				set_text(str(side_effect.amount).join(["Choose "," candy to remove"]))
				return
			Shared.SIDE_EFFECTS.DOWNGRADE_CANDY:
				set_text(str(side_effect.amount).join(["Choose "," candy to downgrade"]))
				return
