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

func use(target: CharacterBase, all_targets: Array[CharacterBase]):
	# Eat the candy
	var power = yum * Shared.get_power_multiplier(level)
	var is_heal = power < 0
	
	# Target eats candy
	target.eat(power)

	# Level effects
	match (level):
		Level.KING_SIZE:
			var random_enemy = get_random_target(all_targets, [target], is_heal)
			random_enemy.eat(power)
		Level.PARTY_SIZE:
			var random_enemy = get_random_target(all_targets, [target], is_heal)
			random_enemy.eat(power)
			
			var random_enemy_2 = get_random_target(all_targets, [target, random_enemy], is_heal)
			random_enemy_2.eat(power)

	# Apply candy special effect
	match (type):
		Candy.NOW_AND_LATER:
			# Do damage again next turn
			target.eat_again(power)
			
			match (level):
				Level.KING_SIZE:
					var random_enemy = get_random_target(all_targets, [target], is_heal)
					random_enemy.eat_again(power)
				Level.PARTY_SIZE:
					var random_enemy = get_random_target(all_targets, [target], is_heal)
					random_enemy.eat_again(power)
					
					var random_enemy_2 = get_random_target(all_targets, [target, random_enemy], is_heal)
					random_enemy_2.eat_again(power)
		Candy.ROCK:
			# Daze
			target.daze()
			
			match (level):
				Level.KING_SIZE:
					var random_enemy = get_random_target(all_targets, [target], is_heal)
					random_enemy.daze()
				Level.PARTY_SIZE:
					var random_enemy = get_random_target(all_targets, [target], is_heal)
					random_enemy.daze()
					
					var random_enemy_2 = get_random_target(all_targets, [target, random_enemy], is_heal)
					random_enemy_2.daze()
		Candy.GUMMY_BEARS:
			print('protecting')
			target.protect(-power)
			
			match (level):
				Level.KING_SIZE:
					var random_enemy = get_random_target(all_targets, [target], is_heal)
					random_enemy.protect(-power)
				Level.PARTY_SIZE:
					var random_enemy = get_random_target(all_targets, [target], is_heal)
					random_enemy.protect(-power)
					
					var random_enemy_2 = get_random_target(all_targets, [target, random_enemy], is_heal)
					random_enemy_2.protect(-power)

		Candy.NERDS_ROPE:
			target.tie_up()
			
			match (level):
				Level.KING_SIZE:
					var random_enemy = get_random_target(all_targets, [target], is_heal)
					random_enemy.tie_up()
				Level.PARTY_SIZE:
					var random_enemy = get_random_target(all_targets, [target], is_heal)
					random_enemy.tie_up()
					
					var random_enemy_2 = get_random_target(all_targets, [target, random_enemy], is_heal)
					random_enemy_2.tie_up()

		Candy.SWEDISH_FISH:
			affect_all_enemies(all_targets, power)
			
			match (level):
				Level.KING_SIZE:
					affect_all_enemies(all_targets, power)
				Level.PARTY_SIZE:
					affect_all_enemies(all_targets, power)
					affect_all_enemies(all_targets, power)


func affect_all_enemies(all_targets: Array[CharacterBase], power: int):
	for target in all_targets:
		target.eat(power)
		
func get_random_target(all_targets: Array[CharacterBase], ignore_targets: Array[CharacterBase], is_heal: bool) -> CharacterBase:
	var valid_targets = all_targets.filter(func (maybe_target):
		var is_valid = not maybe_target in ignore_targets
		# If we're healing, check health, otherwise default to true so we ignore
		var is_not_full_health = maybe_target.is_full_health() if is_heal else true
		return is_valid and is_not_full_health
	)
	
	if valid_targets.is_empty():
		return all_targets.pick_random()
	
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

	texture_path = "/".join(path_parts)
