extends Node

### Characters #################################################################

enum Characters {
	WARRIOR, WIZARD, WITCH
}

func get_character_name(character: Characters):
	match character:
		Characters.WARRIOR:
			return 'Warrior'
		Characters.WIZARD:
			return 'Wizard'
		Characters.WITCH:
			return 'Witch'

### Candy ######################################################################

enum Candy {
	# Unhealthy
	REESES, # 5
	TWIX, # 4
	HERSHEY_BAR, # 4
	KITKAT, # 3
	CRUNCH, # 2
	# Healthy
	LIFESAVERS, # -5
	WERTHERS, # -4
	APPLE, # -4
	HEATH, # -3
	FRUIT_GUMMIES, # -2
	# Special
	ROCK, # 5 Damage and daze someone for a turn
	NOW_AND_LATER, # 4 Damage and attack again next turn
	SWEDISH_FISH, # 3 Damage to all enemies
	GUMMY_BEARS, # Takes damage for you next turn
	NERDS_ROPE, # Tie up someone for next turn
}

var candy_names = {
	# Unhealthy
	Candy.REESES: "REESES",
	Candy.TWIX: "TWIX",
	Candy.HERSHEY_BAR: "HERSHEY BAR",
	Candy.KITKAT: "KIT KAT",
	Candy.CRUNCH: "CRUNCH",
	# Healthy
	Candy.LIFESAVERS: "LIFESAVERS",
	Candy.WERTHERS: "WERTHER'S",
	Candy.APPLE: "APPLE",
	Candy.HEATH: "HEATH BAR",
	Candy.FRUIT_GUMMIES: "FRUIT GUMMIES",
	# Special
	Candy.NOW_AND_LATER: "NOW AND LATER",
	Candy.ROCK: "ROCK",
	Candy.GUMMY_BEARS: "GUMMY BEARS",
	Candy.NERDS_ROPE: "NERDS ROPE",
	Candy.SWEDISH_FISH: "SWEDISH FISH",
}

func get_candy_description(candy: Candy, yum: int, level: CandyLevel):
	var power = abs(yum) * get_power_multiplier(level)
	var base_string = ""
	match candy:
		# Unhealthy
		Candy.REESES:
			base_string = "Deals " + str(power) + " damage."
		Candy.TWIX:
			base_string = "Deals " + str(power) + " damage."
		Candy.HERSHEY_BAR:
			base_string = "Deals " + str(power) + " damage."
		Candy.KITKAT:
			base_string = "Deals " + str(power) + " damage."
		Candy.CRUNCH:
			base_string = "Deals " + str(power) + " damage."
		# Healthy
		Candy.LIFESAVERS:
			base_string = "Heals " + str(power) + " health."
		Candy.WERTHERS:
			base_string = "Heals " + str(power) + " health."
		Candy.APPLE:
			base_string = "Heals " + str(power) + " health."
		Candy.HEATH:
			base_string = "Heals " + str(power) + " health."
		Candy.FRUIT_GUMMIES:
			base_string = "Heals " + str(power) + " health."
		# Special
		Candy.ROCK:
			base_string = "Deals " + str(power) + " damage and dazes the target for a turn.\nWhile dazed, the target cannot attack or use abilities and takes double damages."
		Candy.NOW_AND_LATER:
			base_string = "Deals " + str(power) + " damage and attacks again next turn."
		Candy.GUMMY_BEARS:
			base_string = "Takes " + str(power) + " damage for you next turn."
		Candy.NERDS_ROPE:
			base_string = "Ties up the target for next turn.\nWhile tied, the target cannot attack or use abilities."
		Candy.SWEDISH_FISH:
			base_string = "Deals " + str(power) + " damage to all targets."

	match level:
		CandyLevel.KING_SIZE:
			return base_string + "\n" + "Hits an extra target for half the amount."
		CandyLevel.PARTY_SIZE:
			return base_string + "\n" + "Hits two extra targets for half the amount."

	return base_string


func get_candy_name(candy: Candy):
	return candy_names[candy]

enum CandyLevel {
	FUN_SIZE, REGULAR_SIZE, KING_SIZE, PARTY_SIZE
}

var candy_level_names = {
	CandyLevel.FUN_SIZE: "Fun Size",
	CandyLevel.REGULAR_SIZE: "Regular Size",
	CandyLevel.KING_SIZE: "King Size",
	CandyLevel.PARTY_SIZE: "Party Size"
}

var candy_level_multiplier = {
	CandyLevel.FUN_SIZE: 1,
	CandyLevel.REGULAR_SIZE: 2,
	CandyLevel.KING_SIZE: 3, # Also hits random enemy
	CandyLevel.PARTY_SIZE: 3 # Also hits two extra random enemies
}

func get_power_multiplier(level: CandyLevel) -> int:
	return candy_level_multiplier[level]

func get_candy(candy: Candy, level: CandyLevel = CandyLevel.FUN_SIZE):
	var candy_base = { "type": candy, "level": level }
	match (candy):
		Candy.REESES:
			add_candy_details(candy_base, 5, get_candy_texture_path("reeses", level))
		Candy.TWIX:
			add_candy_details(candy_base, 4, get_candy_texture_path("twix", level))
		Candy.HERSHEY_BAR:
			add_candy_details(candy_base, 4, get_candy_texture_path("hershey", level))
		Candy.KITKAT:
			add_candy_details(candy_base, 3, get_candy_texture_path("kitkat", level))
		Candy.CRUNCH:
			add_candy_details(candy_base, 2, get_candy_texture_path("crunch", level))
		Candy.LIFESAVERS:
			add_candy_details(candy_base, -5, get_candy_texture_path("lifesavers", level))
		Candy.WERTHERS:
			add_candy_details(candy_base, -4, get_candy_texture_path("werthers", level))
		Candy.APPLE:
			add_candy_details(candy_base, -4, get_candy_texture_path("apple", level))
		Candy.HEATH:
			add_candy_details(candy_base, -3, get_candy_texture_path("heath", level))
		Candy.FRUIT_GUMMIES:
			add_candy_details(candy_base, -2, get_candy_texture_path("fruit_gummies", level))
		Candy.ROCK:
			add_candy_details(candy_base, 5, get_candy_texture_path("rock", level))
		Candy.NOW_AND_LATER:
			add_candy_details(candy_base, 4, get_candy_texture_path("now_and_later", level))
		Candy.SWEDISH_FISH:
			add_candy_details(candy_base, 3, get_candy_texture_path("swedish_fish", level))
		Candy.GUMMY_BEARS:
			add_candy_details(candy_base, -2, get_candy_texture_path("gummybears", level))
		Candy.NERDS_ROPE:
			add_candy_details(candy_base, 0, get_candy_texture_path("nerds_rope", level))

	return CandyClass.new(candy_base)

func add_candy_details(base: Dictionary, yum: int, texture_path: String):
	base['yum'] = yum
	base['texture_path'] = texture_path

func get_random_candy(level: CandyLevel = CandyLevel.FUN_SIZE):
	var enum_size = Candy.size()
	var random_index = randi_range(0, enum_size - 1)
	return get_candy(random_index, level)


func get_candy_texture(candy: CandyClass):
	var texture = load(candy.texture_path)

	if texture == null:
		print("No image found for: ", candy.texture_path)
		texture = load(get_candy_texture_path("reeses", candy.level))

	return texture

func get_candy_texture_path(candy_name: String, level: CandyLevel):
	var level_string = ""
	match level:
		CandyLevel.FUN_SIZE:
			level_string = "_fun"
		CandyLevel.REGULAR_SIZE:
			level_string = "_regular"
		CandyLevel.KING_SIZE:
			level_string = "_king"
		CandyLevel.PARTY_SIZE:
			level_string = "_party"

	return "res://art/candy/" + candy_name + level_string + ".png"

func get_candy_name_with_level(candy: CandyClass):
	return get_candy_name(candy.type) + " (" + candy_level_names[candy.level] + ")"

func get_candy_tooltip(candy: CandyClass):
	return get_candy_name(candy.type) + "\n" + "(" + candy_level_names[candy.level] + ")" + "\n" + get_candy_description(candy.type, candy.yum, candy.level)

### House ######################################################################

enum HOUSE_TYPE {
	NORMAL,
	RICH,
	BOSS
}

### Helpers ####################################################################

func proper_case(text):
	return text[0].to_upper() + text.substr(1,-1)

### Treats #####################################################################

# Possible treats
# - Increase max health
# - Increase hand size
# - Upgrade a candy
# - Gain a shield at start of turn
# - Duplicate a candy
# - Remove a candy
# - Make first candy played activate twice
# - Skip next house

# Possible side effects
# - Decrease max health
# - Decrease hand size
# - Downgrade a candy
# - Trigger fight
# - Take damage

enum TREAT_TYPES {
	INCREASE_MAX_HEALTH,
	INCREASE_HAND_SIZE,
	UPGRADE_CANDY,
	GAIN_SHIELD,
	DUPE_CANDY,
	MAKE_FIRST_CANDY_ACTIVATE_TWICE,
	SKIP_NEXT_HOUSE,
	HEAL,
	NONE,
}

enum SIDE_EFFECTS {
	DECREASE_MAX_HEALTH,
	DECREASE_HAND_SIZE,
	DOWNGRADE_CANDY,
	REMOVE_CANDY,
	TRIGGER_FIGHT,
	TAKE_DAMAGE,
	NONE,
}

### Sounds #########3##########################################################

enum SoundType {
	YUM,
	HIT,
	GRAB
}
