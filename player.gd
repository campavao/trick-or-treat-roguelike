extends CharacterBase
class_name Player

const Characters = Shared.Characters
const Candy = Shared.Candy

var character: Characters
var basket: Array[CandyClass]
var hand_size := 4

func _init(state) -> void:
	character = state["character"]
	set_starting_health(20)

	# 4 Unhealthy x 4 Healthy x 2 Special
	var crunch_bar = Shared.get_candy(Shared.Candy.CRUNCH)
	var fruit_gummy = Shared.get_candy(Shared.Candy.FRUIT_GUMMIES)

	# Unhealthy
	add_candies(Shared.Candy.CRUNCH, 4)

	# Healthy
	add_candies(Shared.Candy.FRUIT_GUMMIES, 4)

	# Special
	match character:
		Shared.Characters.WARRIOR:
			# Warrior (Michelanglo - TMNT)
			# Special - Rock
			add_candies(Shared.Candy.ROCK)

		Shared.Characters.WIZARD:
			# Wizard (Scorpian - Mortal Kombat)
			# Special - Now and Later
			add_candies(Shared.Candy.NOW_AND_LATER)

		Shared.Characters.WITCH:
			# Witch (Care bear)
			# Special - Gummy bears
			add_candies(Shared.Candy.GUMMY_BEARS)


func add_candies(candy_type: Shared.Candy, amount = 2):
	for i in amount:
		var candy = Shared.get_candy(candy_type)
		basket.push_back(candy)
