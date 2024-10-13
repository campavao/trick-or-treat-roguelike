extends Node
class_name CharacterBase

var starting_health: int = 10
@export var health: int = 10
var protection := 0

var is_dazed := false
var is_tied_up := false
var eat_at_start_of_turn = null # int or null

func set_starting_health(amount: int):
	health = amount
	starting_health = amount

func is_full_health():
	return health == starting_health

func reset():
	if eat_at_start_of_turn:
		eat(eat_at_start_of_turn)
		eat_at_start_of_turn = null

	# Reset on start of turn
	is_dazed = false
	is_tied_up = false
	protection = 0

# If the amount is positive, we're taking damage
# If the amount is negative, we're healing
func eat(original_amount: int):
	# Prevent healing on full health
	if original_amount < 0 and is_full_health():
		return

	var amount = original_amount

	# Take double damage if dazed
	if is_dazed and amount > 0:
		amount *= 2

	print(self, ' is eating: ', amount)

	if protection > 0 and amount > 0:
		protection -= amount

		# If protection is still strong, or set to 0 then there is no more to eat
		if protection >= 0:
			return

		# If protection is negative, then the amount was too much
		# and we add the negative difference to our health (decreasing it)
		health += protection

		# After applying over-damage, reset protection
		protection = 0
	else:
		health -= amount

		# Don't overfill health
		if health > starting_health:
			health = starting_health

func daze():
	is_dazed = true

func tie_up():
	is_tied_up = true

func eat_again(amount):
	eat_at_start_of_turn = amount

func protect(amount: int):
	protection += amount
