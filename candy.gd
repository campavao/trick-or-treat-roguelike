extends Node
class_name CandyClass

const Candy = Shared.Candy
const Level = Shared.CandyLevel

var type: Candy # e.g. CRUNCH
var level: Shared.CandyLevel # e.g. King Size
var candy_name: String # Readable name
var yum: int # if positive it's tasty, if negative it's healthy
var texture_path: String

func _init(props):
	type = props['type'] if props['type'] else Candy.CRUNCH
	level = props['level'] if props['level'] else Level.FUN_SIZE
	yum = props['yum']
	name = Shared.get_candy_name(type) # this should update the node's name in the tree
	candy_name = Shared.get_candy_name(type)
	texture_path = props['texture_path']

func use(target: Node, all_targets: Array[Node]):
	# Eat the candy
	var power = yum * Shared.get_power_multiplier(level)
	match (level):
		Level.FUN_SIZE, Level.REGULAR_SIZE:
			target.eat(power)
		Level.KING_SIZE:
			target.eat(power)
			var random_enemy = get_random_target(all_targets, [target])
			random_enemy.eat(power)
		Level.PARTY_SIZE:
			var random_enemy = get_random_target(all_targets, [target])
			random_enemy.eat(power)
			
			var random_enemy_2 = get_random_target(all_targets, [target, random_enemy])
			random_enemy_2.eat(power)

	# Apply candy special effect
	match (type):
		Candy.NOW_AND_LATER:
			# Do damage again next turn
			target.eat_again(power)
		Candy.ROCK:
			# Daze
			target.daze()
		Candy.GUMMY_BEARS:
			target.protect()
		Candy.NERDS_ROPE:
			target.tie_up()
		Candy.SWEDISH_FISH:
			affect_all_enemies(all_targets, power)
				

func affect_all_enemies(all_targets: Array[Node], power: int):
	for target in all_targets:
		target.eat(power)
		
func get_random_target(all_targets: Array[Node], ignore_targets: Array[Node]) -> Node2D:
	var valid_targets = all_targets.filter(func (maybe_target):
		return not maybe_target in ignore_targets
	)
	
	return valid_targets.pick_random()

func level_up():
	var path_parts = texture_path.split("/")

	match level:
		Level.FUN_SIZE:
			level = Level.REGULAR_SIZE
			path_parts[3] = path_parts[3].replace("_fun", "_regular")
		Level.REGULAR_SIZE:
			level = Level.KING_SIZE
			path_parts[3] = path_parts[3].replace("_regular", "_king")
		Level.KING_SIZE:
			level = Level.PARTY_SIZE
			path_parts[3] = path_parts[3].replace("_king", "_party")

	texture_path = path_parts.join("/")
