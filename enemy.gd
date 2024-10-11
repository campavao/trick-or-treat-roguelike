extends CharacterBase
class_name Enemy

signal selected(enemy: Enemy)

@export var is_dead := false
@export var is_elite := false

var next_move: MOVES = MOVES.ATTACK

enum MOVES {
	ATTACK, SPECIAL, DEFEND
}

func initialize(starting_health, starting_power):
	pick_next_move()
	
	power = starting_power
	
	health = starting_health
	$HealthBar.value = starting_health
	$HealthBar.max_value = starting_health

func reset():
	super.reset()

	# pick next move
	pick_next_move()

func attack(player):
	if is_dazed or is_tied_up:
		return
		
	match (next_move):
		MOVES.ATTACK:
			player.eat(power)
		MOVES.DEFEND:
			health += power
		MOVES.SPECIAL:
			protect(2)

func eat(amount: int):
	super.eat(amount)
	
	if health <= 0:
		die()

func die():
	# animation and then die?
	# is_dead = true
	queue_free()
	
func daze():
	super.daze()
	$NextMove.texture = preload('res://art/dazed_intent.png')

func tie_up():
	super.tie_up()
	$NextMove.texture = preload('res://art/tied_up_intent.png')


func pick_next_move():
	var enum_size = MOVES.size()

	# If we're at max health, attack or special only
	if health == $HealthBar.max_value:
		enum_size = 1
		
	var random_index = int(randf() * enum_size)  # randf() gives a float in the range [0.0, 1.0)
	next_move = MOVES.values()[random_index]
	
	match next_move:
		MOVES.ATTACK:
			$NextMove.texture = preload('res://art/attack_intent.png')
		MOVES.DEFEND:
			$NextMove.texture = preload('res://art/heal_intent.png')
		MOVES.SPECIAL:
			$NextMove.texture = preload('res://art/protection_intent.png')

func _on_pressed() -> void:
	selected.emit(self)

func _process(_delta):
	$HealthBar.value = health
	$ProtectionAmount.text = str(protection)
		
	if protection > 0:
		$ProtectionIcon.show()
		$ProtectionAmount.show()
	else:
		$ProtectionIcon.hide()
		$ProtectionAmount.hide()
