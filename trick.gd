extends Node2D

signal complete()

const ENEMY_SCENE = preload('res://enemy.tscn')

var player_ref: Player
var basket_ref: Array[CandyClass]

func enable(player: Player, type: Shared.HOUSE_TYPE):
	show()

	# Reference the current player
	player_ref = player
	reset_basket()

	# Setup enemy
	setup_enemies(type)

	# Setup player
	$Player.init(player)

	# Start player turn
	start_player_turn()

func _on_button_pressed() -> void:
	hide()
	reset_enemies()
	
	complete.emit()
	
func reset_enemies():
	for enemy in $EnemyContainer.get_children():
		enemy.queue_free()
		
func reset_basket():
	basket_ref = player_ref.basket.duplicate()
	basket_ref.shuffle()

func setup_enemies(type: Shared.HOUSE_TYPE):
	var amount = randi_range(1, 4) # Random int between 1 and 4
	for i in amount:
		var enemy = ENEMY_SCENE.instantiate()
		var rich_multiplier = 2 if type == Shared.HOUSE_TYPE.RICH else 1
		enemy.initialize(20 * rich_multiplier, 2 * rich_multiplier)

		$EnemyContainer.add_child(enemy)

func start_player_turn():
	# Render candy from basket
	for i in 4:
		var candy = basket_ref.pop_back()
		
		# Out of candy, shuffle in the discard pile
		if candy == null:
			reset_basket()
			candy = basket_ref.pop_back()

		var candy_node = preload('res://candy_display.tscn').instantiate()
		candy_node.initialize(candy)
		$CandyContainer.add_child(candy_node)
	
	# Use candy against enemies
	# Hit end turn button
	


func start_enemy_turn():
	for enemy in $EnemyContainer.get_children():
		enemy.attack(player_ref)
	
	start_player_turn()


func _on_done_pressed() -> void:
	start_enemy_turn()
