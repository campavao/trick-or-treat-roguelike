extends Node2D

signal complete()

const ENEMY_SCENE = preload('res://enemy.tscn')

var player_ref: Player

# All possible candy
var basket_ref: Array[CandyClass]

# Used candy
var used_candy: Array[CandyClass]

# Candy in hand
var hand: Array[CandyClass]

var selected_candy: CandyClass

func enable(player: Player, type: Shared.HOUSE_TYPE):
	show()

	# Reference the current player
	player_ref = player
	reset_basket(player.basket)

	# Setup enemy
	setup_enemies(type)

	# Setup player
	$Player.init(player)

	# Start player turn
	start_player_turn()

func _on_button_pressed() -> void:
	finish()
	
func finish(is_complete: bool = true):
	hide()
	reset_enemies()
	clear_hand()
	
	if is_complete:
		complete.emit()
	
func reset_enemies():
	for enemy in $EnemyContainer.get_children():
		enemy.queue_free()
		
func reset_basket(source: Array[CandyClass], clear: bool = false):
	basket_ref = source.duplicate()
	
	if clear:
		source.clear()
		
	basket_ref.shuffle()
	
func clear_hand():
	$CandyContainer.clear()
	hand.clear()
	used_candy.clear()

func setup_enemies(type: Shared.HOUSE_TYPE):
	var amount = randi_range(1, 4) # Random int between 1 and 4
	for i in amount:
		var enemy = ENEMY_SCENE.instantiate()
		var rich_multiplier = 2 if type == Shared.HOUSE_TYPE.RICH else 1
		enemy.initialize(20 * rich_multiplier, 2 * rich_multiplier)
		enemy.connect('selected', _on_enemy_press)

		$EnemyContainer.add_child(enemy)

func start_player_turn():
	# Render candy from basket
	for i in 4:
		var candy = basket_ref.pop_back()
		
		# Out of candy, shuffle in the used pile
		if candy == null:
			reset_basket(used_candy, true)
			candy = basket_ref.pop_back()
			
			# If there is nothing in the used pile, all cards must be in hand
			if candy == null:
				print('No more cards in used pile')
				return
			
		hand.push_back(candy)
		var candy_texture = Shared.get_candy_texture(candy.texture_path)
		$CandyContainer.add_item(candy.name, candy_texture, i + 1)
	
	# Use candy against enemies
	# Hit end turn button


func start_enemy_turn():
	for enemy in $EnemyContainer.get_children():
		enemy.attack(player_ref)
		
	for enemy in $EnemyContainer.get_children():
		enemy.reset()
	
	start_player_turn()


func _on_done_pressed() -> void:
	start_enemy_turn()

func _on_enemy_press(enemy: Enemy):
	var all_enemies = $EnemyContainer.get_children()
	on_activate_candy(enemy, all_enemies)

func _on_player_pressed() -> void:
	on_activate_candy(player_ref, [player_ref])

func on_activate_candy(target: Node, all_targets: Array[Node]):
	var possible_index = $CandyContainer.get_selected_items()
	if possible_index.size() == 0:
		return
	
	var selected_candy_index = possible_index[0]
	
	$CandyContainer.remove_item(selected_candy_index)
	var candy = hand.pop_at(selected_candy_index)
	candy.use(target, all_targets)
	used_candy.push_back(candy)

func _process(delta: float) -> void:
	if not visible:
		return
		
	if $EnemyContainer.get_children().size() == 0:
		finish()

	if player_ref.health <= 0:
		finish(false)
