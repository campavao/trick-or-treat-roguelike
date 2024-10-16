extends Node2D

signal complete()
signal upgrade_candy(amount: int)
signal remove_candy(amount: int)
signal duplicate_candy(amount: int)
signal downgrade_candy(amount: int)
signal trigger_fight(type: Shared.HOUSE_TYPE)

const TREAT_TYPES = Shared.TREAT_TYPES
const SIDE_EFFECTS = Shared.SIDE_EFFECTS

const TREAT_DATA = {
	TREAT_TYPES.INCREASE_MAX_HEALTH: {
		"value": 10,
		"text": ["Increase max health by", ""],
	},
	TREAT_TYPES.INCREASE_HAND_SIZE: {
		"value": 1,
		"text": ["Increase hand size by", ""],
	},
	TREAT_TYPES.UPGRADE_CANDY: {
		"value": 1,
		"text": ["Upgrade", "candy"],
	},
	TREAT_TYPES.GAIN_SHIELD: {
		"value": 1,
		"text": ["Gain", "shield at start of turn"],
	},
	TREAT_TYPES.DUPE_CANDY: {
		"value": 1,
		"text": ["Duplicate", "candy"],
	},
	TREAT_TYPES.MAKE_FIRST_CANDY_ACTIVATE_TWICE: {
		"value": 0,
		"text": ["Make first candy played activate twice"],
	},
	TREAT_TYPES.SKIP_NEXT_HOUSE: {
		"value": 0,
		"text": ["Skip next house"],
	},
	TREAT_TYPES.HEAL: {
		"value": 5,
		"text": ["Heal for", ""],
	},
	TREAT_TYPES.NONE: {
		"value": 0,
		"text": "",
	},
}

const SIDE_EFFECT_DATA = {
	SIDE_EFFECTS.DECREASE_MAX_HEALTH: {
		"value": 5,
		"text": ["decrease max health by ", ""],
	},
	SIDE_EFFECTS.DECREASE_HAND_SIZE: {
		"value": 1,
		"text": ["decrease hand size by", ""],
	},
	SIDE_EFFECTS.DOWNGRADE_CANDY: {
		"value": 1,
		"text": ["downgrade", "candy"],
	},
	SIDE_EFFECTS.REMOVE_CANDY: {
		"value": 1,
		"text": ["remove", "candy"],
	},
	SIDE_EFFECTS.TRIGGER_FIGHT: {
		"value": 1,
		"text": ['trigger', 'fight']
	},
	SIDE_EFFECTS.TAKE_DAMAGE: {
		"value": 5,
		"text": ['take', 'damage']
	},
	SIDE_EFFECTS.NONE: {
		"value": 0,
		"text": "",
	},
}

var options: Array[TreatOption] = []
var player_ref: Player

var current_effect: TREAT_TYPES
var current_side_effect: SIDE_EFFECTS

func enable(player: Player, type: Shared.HOUSE_TYPE):
	player_ref = player
	show()
	for i in 3:
		var random_type = TREAT_TYPES.keys()[randi() % TREAT_TYPES.size()]
		var random_side_effect = SIDE_EFFECTS.keys()[randi() % SIDE_EFFECTS.size()]
		var option = TreatOption.new(TREAT_TYPES[random_type], SIDE_EFFECTS[random_side_effect], type == Shared.HOUSE_TYPE.RICH)
		options.append(option)
		$Options.add_item(option.text, null, true)


func _on_button_pressed() -> void:
	hide()
	complete.emit()

func finish():
	hide()
	complete.emit()
	options.clear()
	$Options.clear()

class TreatOption:
	var type: TREAT_TYPES
	var side_effect: SIDE_EFFECTS
	var enhanced: bool = false
	# Example: "Increase max health by 10, but take 5 damage"
	var text: String

	func _init(init_type: TREAT_TYPES, init_side_effect: SIDE_EFFECTS, init_enhanced: bool = false):
		type = init_type
		side_effect = init_side_effect
		enhanced = init_enhanced
		var is_none_type = type == TREAT_TYPES.NONE

		if not is_none_type:
			var value = TREAT_DATA[type].value if not enhanced else TREAT_DATA[type].value * 2
			var value_text = " " + str(value) + " "
			text = value_text.join(TREAT_DATA[type].text)

		if side_effect != SIDE_EFFECTS.NONE:
			var value = SIDE_EFFECT_DATA[side_effect].value if not enhanced else SIDE_EFFECT_DATA[side_effect].value * 2
			var value_text = " " + str(value) + " "
			if side_effect == SIDE_EFFECTS.TRIGGER_FIGHT:
				if value == 2:
					value_text = " a rich house "
				else:
					value_text = " a house "
			var info_text = value_text.join(SIDE_EFFECT_DATA[side_effect].text)

			if not is_none_type:
				text += ", but " + info_text
			else:
				text = Shared.proper_case(info_text)


func _on_options_item_selected(index: int) -> void:
	var option: TreatOption = options[index]

	match option.type:
		TREAT_TYPES.INCREASE_MAX_HEALTH:
			var value = get_treat_value(option.type, option.enhanced)
			player_ref.health += value
			player_ref.starting_health += value
		TREAT_TYPES.INCREASE_HAND_SIZE:
			var value = get_treat_value(option.type, option.enhanced)
			player_ref.hand_size += value
		TREAT_TYPES.UPGRADE_CANDY:
			var value = get_treat_value(option.type, option.enhanced)
			upgrade_candy.emit(value)
		TREAT_TYPES.GAIN_SHIELD:
			var value = get_treat_value(option.type, option.enhanced)
			player_ref.start_turn_shield_amount = value
		TREAT_TYPES.DUPE_CANDY:
			var value = get_treat_value(option.type, option.enhanced)
			duplicate_candy.emit(value)
		TREAT_TYPES.MAKE_FIRST_CANDY_ACTIVATE_TWICE:
			player_ref.use_first_candy_twice = true
		TREAT_TYPES.SKIP_NEXT_HOUSE:
			player_ref.skip_next_house = true
		TREAT_TYPES.HEAL:
			var value = get_treat_value(option.type, option.enhanced)
			player_ref.heal(value)
		TREAT_TYPES.NONE:
			pass

	match option.side_effect:
		SIDE_EFFECTS.DECREASE_MAX_HEALTH:
			var value = get_side_effect_value(option.side_effect, option.enhanced)
			player_ref.health -= value
			player_ref.starting_health -= value
		SIDE_EFFECTS.DECREASE_HAND_SIZE:
			var value = get_side_effect_value(option.side_effect, option.enhanced)
			player_ref.hand_size -= value
		SIDE_EFFECTS.DOWNGRADE_CANDY:
			var value = get_side_effect_value(option.side_effect, option.enhanced)
			downgrade_candy.emit(value)
		SIDE_EFFECTS.REMOVE_CANDY:
			var value = get_side_effect_value(option.side_effect, option.enhanced)
			remove_candy.emit(value)
		SIDE_EFFECTS.TRIGGER_FIGHT:
			var value = get_side_effect_value(option.side_effect, option.enhanced)
			trigger_fight.emit(Shared.HOUSE_TYPE.RICH if value == 2 else Shared.HOUSE_TYPE.NORMAL)
		SIDE_EFFECTS.TAKE_DAMAGE:
			var value = get_side_effect_value(option.side_effect, option.enhanced)
			player_ref.health -= value
		SIDE_EFFECTS.NONE:
			pass

	finish()

func get_treat_value(type: TREAT_TYPES, enhanced: bool):
	return TREAT_DATA[type].value if not enhanced else TREAT_DATA[type].value * 2

func get_side_effect_value(type: SIDE_EFFECTS, enhanced: bool):
	return SIDE_EFFECT_DATA[type].value if not enhanced else SIDE_EFFECT_DATA[type].value * 2
