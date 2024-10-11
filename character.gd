extends Node
class_name CharacterBase

@export var health: int = 10
@export var power: int = 2
var protection := 0

var is_dazed := false
var is_tied_up := false
var eat_at_start_of_turn = null # int or null

func reset():
	if eat_at_start_of_turn:
		eat(eat_at_start_of_turn)
		eat_at_start_of_turn = null

	# Reset on start of turn
	is_dazed = false
	is_tied_up = false


func eat(original_amount: int):
	var amount = original_amount
	
	# Take double damage if dazed
	if is_dazed:
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

func daze():
	is_dazed = true

func tie_up():
	is_tied_up = true

func eat_again(amount):
	eat_at_start_of_turn = amount

func protect(amount: int):
	protection += amount
