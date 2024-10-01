extends Node
class_name Enemy

@export var health: int = 10
@export var power: int = 2
@export var is_dead := false
@export var is_elite := false

var is_dazed := false
var is_tied_up := false
var next_move: MOVES = MOVES.ATTACK
var eat_at_start_of_turn = null # int or null

enum MOVES {
	ATTACK, DEFEND, SPECIAL
}

func initialize(starting_health, starting_power):
	pick_next_move()
	
	power = starting_power
	
	health = starting_health
	$HealthBar.value = starting_health
	$HealthBar.max_value = starting_health

func start_turn():
	if eat_at_start_of_turn:
		eat(eat_at_start_of_turn)
		eat_at_start_of_turn = null

	# Reset on start of turn
	is_dazed = false
	is_tied_up = false

	# pick next move
	pick_next_move()

func attack(player):
	match (next_move):
		MOVES.ATTACK, MOVES.SPECIAL:
			player.eat(power)
		MOVES.DEFEND:
			health += power

func eat(amount: int):
	health -= amount
	if health <= 0:
		die()

func daze():
	is_dazed = true

func tie_up():
	is_tied_up = true

func eat_again(amount):
	eat_at_start_of_turn = amount

func die():
	# animation
	is_dead = true

func pick_next_move():
	var enum_size = MOVES.size()
	var random_index = int(randf() * enum_size)  # randf() gives a float in the range [0.0, 1.0)
	next_move = MOVES.values()[random_index]
