extends CharacterBase
class_name Player

const Characters = Shared.Characters
const Candy = Shared.Candy

var character: Characters
var basket: Array[CandyClass]

func _init(state) -> void:
	character = state["character"]
	set_starting_health(20)
	
	# 4 Unhealthy x 4 Healthy x 2 Special
	var crunch_bar = Shared.get_candy(Shared.Candy.CRUNCH)
	var fruit_gummy = Shared.get_candy(Shared.Candy.FRUIT_GUMMIES)

	# Unhealthy
	add_candies(crunch_bar, 4)

	# Healthy
	add_candies(fruit_gummy, 4)

	# Special
	match character:
		Shared.Characters.WARRIOR:
			# Warrior (Michelanglo - TMNT)
			# Special - Rock
			var rock = Shared.get_candy(Shared.Candy.ROCK)
			add_candies(rock)

		Shared.Characters.WIZARD:
			# Wizard (Scorpian - Mortal Kombat)
			# Special - Now and Later
			var now_and_later = Shared.get_candy(Shared.Candy.NOW_AND_LATER)
			add_candies(now_and_later)

		Shared.Characters.WITCH:
			# Witch (Care bear)
			# Special - Gummy bears
			var gummy_bears = Shared.get_candy(Shared.Candy.GUMMY_BEARS)
			add_candies(gummy_bears)
			

func add_candies(candy, amount = 2):
	for i in amount:
		basket.push_back(candy)
