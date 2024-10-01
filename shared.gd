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
	SWEDISH_FISH, # 3 Damage to two enemies
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

func get_candy_name(candy: Candy):
	return candy_names[candy]

enum CandyLevel {
	FUN_SIZE, REGULAR_SIZE, KING_SIZE, PARTY_SIZE
}

var candy_level_multiplier = {
	CandyLevel.FUN_SIZE: 0, 
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
			add_candy_details(candy_base, 5, "res://art/candy/reeses_fun.png")
		Candy.TWIX:
			add_candy_details(candy_base, 4, "res://art/candy/twix_fun.png")
		Candy.HERSHEY_BAR:
			add_candy_details(candy_base, 4, "res://art/candy/hershey_fun.png")
		Candy.KITKAT:
			add_candy_details(candy_base, 3, "res://art/candy/kitkat_fun.png")
		Candy.CRUNCH:
			add_candy_details(candy_base, 2, "res://art/candy/crunch_fun.png")
		Candy.LIFESAVERS:
			add_candy_details(candy_base, -5, "res://art/candy/lifesavers_fun.png")
		Candy.WERTHERS:
			add_candy_details(candy_base, -4, "res://art/candy/werthers_fun.png")
		Candy.APPLE:
			add_candy_details(candy_base, -4, "res://art/candy/apple_fun.png")
		Candy.HEATH:
			add_candy_details(candy_base, -3, "res://art/candy/heath_fun.png")
		Candy.FRUIT_GUMMIES:
			add_candy_details(candy_base, -2, "res://art/candy/fruit_gummies_fun.png")
		Candy.ROCK:
			add_candy_details(candy_base, 5, "res://art/candy/rock_fun.png")
		Candy.NOW_AND_LATER:
			add_candy_details(candy_base, 4, "res://art/candy/now_and_later_fun.png")
		Candy.SWEDISH_FISH:
			add_candy_details(candy_base, 3, "res://art/candy/swedish_fish_fun.png")
		Candy.GUMMY_BEARS:
			add_candy_details(candy_base, 0, "res://art/candy/gummy_bears_fun.png")
		Candy.NERDS_ROPE:
			add_candy_details(candy_base, 0, "res://art/candy/nerds_rope_fun.png")
			
	return CandyClass.new(candy_base)

func add_candy_details(base: Dictionary, yum: int, texture_path: String):
	base['yum'] = yum
	base['texture_path'] = texture_path

func get_random_candy():
	var enum_size = Candy.size()
	var random_index = int(randf() * enum_size)  # randf() gives a float in the range [0.0, 1.0)
	return get_candy(random_index)

### House ######################################################################

enum HOUSE_TYPE {
	NORMAL,
	RICH
}
