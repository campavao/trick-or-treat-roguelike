extends CharacterBase
class_name Enemy

signal selected(enemy: Enemy)

@export var is_dead := false
@export var is_elite := false
@export var power: int = 2

var next_move: MOVES = MOVES.ATTACK

enum MOVES {
	ATTACK = 0,
	SPECIAL = 1,
	DEFEND = 2
}

func initialize(init_health: int, starting_power: int, is_rich: bool):
	pick_next_move()

	power = starting_power
	is_elite = is_rich

	set_starting_health(init_health)
	$HealthBar.value = init_health
	$HealthBar.max_value = init_health
	$HealthBarLabel.text = str(init_health) + " / " + str(init_health)

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
	if is_full_health():
		enum_size = 1

	var random_index = randi_range(0, enum_size - 1)
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
	$HealthBarLabel.text = str(health) + " / " + str(starting_health)
	if protection > 0:
		$ProtectionIcon.show()
		$ProtectionAmount.show()
	else:
		$ProtectionIcon.hide()
		$ProtectionAmount.hide()
