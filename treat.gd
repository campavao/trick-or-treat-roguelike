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
		"text": ["Increase max health by ", ""],
	},
	TREAT_TYPES.INCREASE_HAND_SIZE: {
		"value": 1,
		"text": ["Increase hand size by ", ""],
	},
	TREAT_TYPES.UPGRADE_CANDY: {
		"value": 1,
		"text": ["Upgrade ", " candy"],
	},
	TREAT_TYPES.GAIN_SHIELD: {
		"value": 1,
		"text": ["Gain ", " shield at start of turn"],
	},
	TREAT_TYPES.DUPE_CANDY: {
		"value": 1,
		"text": ["Duplicate ", " candy"],
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
		"text": ["Heal for ", ""],
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
		"text": ["decrease hand size by ", ""],
	},
	SIDE_EFFECTS.DOWNGRADE_CANDY: {
		"value": 1,
		"text": ["downgrade ", " candy"],
	},
	SIDE_EFFECTS.REMOVE_CANDY: {
		"value": 1,
		"text": ["remove ", " candy"],
	},
	SIDE_EFFECTS.TRIGGER_FIGHT: {
		"value": 1,
		"text": ['trigger ', ' fight']
	},
	SIDE_EFFECTS.TAKE_DAMAGE: {
		"value": 5,
		"text": ['take ', ' damage']
	},
	SIDE_EFFECTS.NONE: {
		"value": 0,
		"text": "",
	},
}

const VALID_COMBOS = {
	TREAT_TYPES.INCREASE_MAX_HEALTH: [SIDE_EFFECTS.NONE, SIDE_EFFECTS.TAKE_DAMAGE, SIDE_EFFECTS.TRIGGER_FIGHT, SIDE_EFFECTS.REMOVE_CANDY, SIDE_EFFECTS.DECREASE_HAND_SIZE, SIDE_EFFECTS.DOWNGRADE_CANDY],
	TREAT_TYPES.INCREASE_HAND_SIZE: [SIDE_EFFECTS.NONE, SIDE_EFFECTS.TAKE_DAMAGE, SIDE_EFFECTS.TRIGGER_FIGHT, SIDE_EFFECTS.REMOVE_CANDY, SIDE_EFFECTS.DECREASE_MAX_HEALTH, SIDE_EFFECTS.DOWNGRADE_CANDY],
	TREAT_TYPES.UPGRADE_CANDY: [SIDE_EFFECTS.NONE, SIDE_EFFECTS.TAKE_DAMAGE, SIDE_EFFECTS.TRIGGER_FIGHT, SIDE_EFFECTS.REMOVE_CANDY, SIDE_EFFECTS.DECREASE_MAX_HEALTH,SIDE_EFFECTS.DECREASE_MAX_HEALTH, SIDE_EFFECTS.DOWNGRADE_CANDY],
	TREAT_TYPES.GAIN_SHIELD: [SIDE_EFFECTS.NONE, SIDE_EFFECTS.TAKE_DAMAGE, SIDE_EFFECTS.TRIGGER_FIGHT, SIDE_EFFECTS.REMOVE_CANDY, SIDE_EFFECTS.DECREASE_MAX_HEALTH,SIDE_EFFECTS.DECREASE_MAX_HEALTH, SIDE_EFFECTS.DOWNGRADE_CANDY],
	TREAT_TYPES.DUPE_CANDY: [SIDE_EFFECTS.NONE, SIDE_EFFECTS.TAKE_DAMAGE, SIDE_EFFECTS.TRIGGER_FIGHT, SIDE_EFFECTS.REMOVE_CANDY, SIDE_EFFECTS.DECREASE_MAX_HEALTH,SIDE_EFFECTS.DECREASE_MAX_HEALTH, SIDE_EFFECTS.DOWNGRADE_CANDY],
	TREAT_TYPES.MAKE_FIRST_CANDY_ACTIVATE_TWICE: [SIDE_EFFECTS.NONE, SIDE_EFFECTS.TAKE_DAMAGE, SIDE_EFFECTS.TRIGGER_FIGHT, SIDE_EFFECTS.REMOVE_CANDY, SIDE_EFFECTS.DECREASE_MAX_HEALTH,SIDE_EFFECTS.DECREASE_MAX_HEALTH, SIDE_EFFECTS.DOWNGRADE_CANDY],
	TREAT_TYPES.SKIP_NEXT_HOUSE: [SIDE_EFFECTS.NONE, SIDE_EFFECTS.TAKE_DAMAGE, SIDE_EFFECTS.TRIGGER_FIGHT, SIDE_EFFECTS.REMOVE_CANDY, SIDE_EFFECTS.DECREASE_MAX_HEALTH,SIDE_EFFECTS.DECREASE_MAX_HEALTH, SIDE_EFFECTS.DOWNGRADE_CANDY],
	TREAT_TYPES.HEAL: [SIDE_EFFECTS.NONE, SIDE_EFFECTS.TAKE_DAMAGE, SIDE_EFFECTS.TRIGGER_FIGHT, SIDE_EFFECTS.REMOVE_CANDY, SIDE_EFFECTS.DECREASE_MAX_HEALTH,SIDE_EFFECTS.DECREASE_MAX_HEALTH, SIDE_EFFECTS.DOWNGRADE_CANDY],
	TREAT_TYPES.NONE: [SIDE_EFFECTS.TAKE_DAMAGE, SIDE_EFFECTS.TRIGGER_FIGHT, SIDE_EFFECTS.REMOVE_CANDY, SIDE_EFFECTS.DECREASE_MAX_HEALTH,SIDE_EFFECTS.DECREASE_MAX_HEALTH, SIDE_EFFECTS.DOWNGRADE_CANDY],
}

var options: Array[TreatOption] = []
var player_ref: Player

var current_effect: TREAT_TYPES
var current_side_effect: SIDE_EFFECTS

func enable(player: Player, type: Shared.HOUSE_TYPE):
	player_ref = player
	show()
	var valid_combos = VALID_COMBOS.keys().duplicate()
	for i in 3:
		var valid_type = get_valid_effect(valid_combos)
		valid_combos.remove_at(valid_combos.find(valid_type))
		var valid_side_effect = get_valid_side_effect(valid_type, type)
		var option = TreatOption.new(valid_type, valid_side_effect, type == Shared.HOUSE_TYPE.RICH)
		options.append(option)
		
		match i:
			0: $"OptionContainer/Option 1".text = option.text
			1: $"OptionContainer/Option 2".text = option.text
			2: $"OptionContainer/Option 3".text = option.text
		
func get_valid_effect(valid_combos: Array):
	var is_all_upgraded = player_ref.basket.all(func (candy): candy.level == Shared.CandyLevel.PARTY_SIZE)
	if is_all_upgraded:
		var idx = valid_combos.find(TREAT_TYPES.UPGRADE_CANDY)
		valid_combos.remove_at(idx)
		
	if player_ref.health == player_ref.starting_health:
		var idx = valid_combos.find(TREAT_TYPES.HEAL)
		valid_combos.remove_at(idx)
		
	return valid_combos.pick_random()

func get_valid_side_effect(type: TREAT_TYPES, house_type: Shared.HOUSE_TYPE):
	var valid_combo: Array = VALID_COMBOS[type].duplicate()
	if player_ref.hand_size <= 2:
		var idx = valid_combo.find(SIDE_EFFECTS.DECREASE_HAND_SIZE)
		valid_combo.remove_at(idx)
		
	var health_safety = 5 if house_type == Shared.HOUSE_TYPE.NORMAL else 10
	if player_ref.health <= health_safety:
		var idx = valid_combo.find(SIDE_EFFECTS.DECREASE_MAX_HEALTH)
		valid_combo.remove_at(idx)
		
	var is_downgradable_candy_found = player_ref.basket.find(func (candy): return candy.level != Shared.CandyLevel.FUN_SIZE)
	if is_downgradable_candy_found:
		var idx = valid_combo.find(SIDE_EFFECTS.DOWNGRADE_CANDY)
		valid_combo.remove_at(idx)
		
	var is_not_enough_candy = player_ref.basket.size() <= 2
	if is_not_enough_candy:
		var idx = valid_combo.find(SIDE_EFFECTS.REMOVE_CANDY)
		valid_combo.remove_at(idx)
		
	return valid_combo.pick_random()

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
			var value_text = str(value)
			text = value_text.join(TREAT_DATA[type].text)

		if side_effect != SIDE_EFFECTS.NONE:
			var value = SIDE_EFFECT_DATA[side_effect].value if not enhanced else SIDE_EFFECT_DATA[side_effect].value * 2
			var value_text = str(value)
			if side_effect == SIDE_EFFECTS.TRIGGER_FIGHT:
				if value == 2:
					value_text = "a rich house"
				else:
					value_text = "a house"
			var info_text = value_text.join(SIDE_EFFECT_DATA[side_effect].text)

			if not is_none_type:
				text += ", but " + info_text
			else:
				text = Shared.proper_case(info_text)


func select_option(index: int) -> void:
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


func _on_option_1_pressed() -> void:
	select_option(0)


func _on_option_2_pressed() -> void:
	select_option(1)


func _on_option_3_pressed() -> void:
	select_option(2)
