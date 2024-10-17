extends Node2D

signal complete(is_boss_house: bool)

const ENEMY_SCENE = preload('res://enemy.tscn')
const HOUSE_BG = preload('res://art/house background.png')
const RICH_HOUSE_BG = preload('res://art/rich house background.png')
const BOSS_HOUSE_BG = preload('res://art/boss house background.png')

var player_ref: Player

# All possible candy
var basket_ref: Array[CandyClass]

# Used candy
var used_candy: Array[CandyClass]

# Candy in hand
var hand: Array[CandyClass]

# Rewards at end
var rewards: Array[CandyClass]

var selected_candy: CandyClass

var max_amount_of_enemies := 4

var can_use_first_candy_twice := false

var is_boss_house := false


func enable(player: Player, type: Shared.HOUSE_TYPE, max_amount: int, difficulty_multiplier: int, is_first_trick: bool = false):
	show()

	max_amount_of_enemies = max_amount
	is_boss_house = type == Shared.HOUSE_TYPE.BOSS
		
	match type:
		Shared.HOUSE_TYPE.NORMAL:
			$Background.texture = HOUSE_BG
		Shared.HOUSE_TYPE.RICH:
			$Background.texture = RICH_HOUSE_BG
		Shared.HOUSE_TYPE.BOSS:
			$Background.texture = BOSS_HOUSE_BG


	# Reference the current player
	player_ref = player
	reset_basket(player.basket)

	# Setup enemy
	setup_enemies(type, difficulty_multiplier, is_first_trick)

	# Setup player
	$Player.init(player)

	# Setup rewards
	setup_rewards(type)

	# Start player turn
	start_player_turn()

func _on_button_pressed() -> void:
	finish()

func finish(is_complete: bool = true):
	hide()
	reset_enemies()
	reset_hand()
	clear_rewards()

	if is_complete:
		complete.emit(is_boss_house)

func reset_enemies():
	for enemy in $EnemyContainer.get_children():
		enemy.queue_free()

func reset_basket(source: Array[CandyClass], clear: bool = false):
	basket_ref = source.duplicate()

	if clear:
		source.clear()

	basket_ref.shuffle()

func reset_hand():
	$CandyContainer.clear()
	hand.clear()
	used_candy.clear()

func clear_rewards():
	$RewardContainer.hide()
	$RewardContainer/CandyPicker.clear()
	rewards.clear()

func setup_enemies(type: Shared.HOUSE_TYPE, difficulty_multiplier: int, is_first_trick: bool = false):
	# Pick set of enemies
	var is_boss = type == Shared.HOUSE_TYPE.BOSS
	var pair: Array
	
	if is_first_trick:
		pair = ENEMY_PAIRINGS[0]
	elif is_boss:
		pair = BOSS_ENEMY_PAIRING
	else:
		var pair_index = randi_range(0, ENEMY_PAIRINGS.size() - 1) # Random int between 1 and 4
		pair = ENEMY_PAIRINGS[pair_index]
		
	print(pair)
	
	# Populate with that set
	for set_of_enemies in pair:
		var enemy = ENEMY_SCENE.instantiate()
		var is_rich = type == Shared.HOUSE_TYPE.RICH
		var rich_multiplier = 2 if is_rich else 1
		match type:
			Shared.HOUSE_TYPE.NORMAL:
				rich_multiplier = 1
			Shared.HOUSE_TYPE.RICH, Shared.HOUSE_TYPE.BOSS:
				rich_multiplier = 2

		var standard_health_multiplier = set_of_enemies.health * difficulty_multiplier
		var standard_attack_multiplier = set_of_enemies.attack * difficulty_multiplier
		var health = standard_health_multiplier * rich_multiplier
		var attack = standard_attack_multiplier * rich_multiplier

		var texture = ENEMY_TEXTURES.pick_random()

		if is_boss:
			texture = BOSS_ENEMY_PAIRING_TEXTURE

		enemy.initialize(health, attack, is_rich, texture)
		enemy.connect('selected', _on_enemy_press)
		enemy.name = "Enemy"

		$EnemyContainer.add_child(enemy)
		print($EnemyContainer.get_children())

func start_player_turn():
	if player_ref.start_turn_shield_amount > 0:
		player_ref.protect(player_ref.start_turn_shield_amount)

	can_use_first_candy_twice = true

	# Render candy from basket
	for i in player_ref.hand_size:
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
		var candy_texture = Shared.get_candy_texture(candy)
		var index = $CandyContainer.add_item(candy.name, candy_texture, true)
		$CandyContainer.set_item_tooltip(index, Shared.get_candy_tooltip(candy))
		$CandyContainer.set_item_tooltip_enabled(index, true)

func clear_hand():
	$CandyContainer.clear()
	used_candy.append_array(hand)
	hand.clear()


func start_enemy_turn():
	clear_hand()

	for enemy in get_all_enemies():
		enemy.attack(player_ref)

	for enemy in get_all_enemies():
		enemy.reset()

	start_player_turn()

func get_all_enemies() -> Array[CharacterBase]:
	var enemy_children: Array[CharacterBase] = []
	for child in $EnemyContainer.get_children():
		if child is Enemy:
			enemy_children.append(child)

	return enemy_children

func _on_done_pressed() -> void:
	start_enemy_turn()

func _on_enemy_press(enemy: Enemy):
	var all_enemies = get_all_enemies()
	on_activate_candy(enemy, all_enemies)

func _on_player_pressed() -> void:
	on_activate_candy(player_ref, [player_ref])

func on_activate_candy(target: CharacterBase, all_targets: Array[CharacterBase]):
	var possible_index = $CandyContainer.get_selected_items()
	if possible_index.size() == 0:
		return

	var selected_candy_index = possible_index[0]

	$CandyContainer.remove_item(selected_candy_index)
	var candy = hand.pop_at(selected_candy_index)
	candy.use(target, all_targets)
	if player_ref.use_first_candy_twice and can_use_first_candy_twice:
		candy.use(target, all_targets)
		can_use_first_candy_twice = false

	used_candy.push_back(candy)

func _process(_delta: float) -> void:
	if not visible:
		return

	if $EnemyContainer.get_children().size() == 0:
		print('end')
		print($EnemyContainer.get_children())

		# no rewards after boss house (for mvp)
		if is_boss_house:
			finish()

		show_rewards()

	if player_ref.health <= 0:
		finish(false)


func setup_rewards(type: Shared.HOUSE_TYPE):
	for i in 3:
		var random_candy_level = randf_range(0.0, 1.0)
		var rich = type == Shared.HOUSE_TYPE.RICH
		var fun_size = 0.1 if rich else 0.6
		var regular_size = 0.5 if rich else 0.85
		var king_size = 0.9 if rich else 0.95

		if random_candy_level <= fun_size:
			add_reward(Shared.CandyLevel.FUN_SIZE)
		elif random_candy_level <= regular_size:
			add_reward(Shared.CandyLevel.REGULAR_SIZE)
		elif random_candy_level <= king_size:
			add_reward(Shared.CandyLevel.KING_SIZE)
		else:
			add_reward(Shared.CandyLevel.PARTY_SIZE)


func add_reward(level: Shared.CandyLevel):
	var candy = Shared.get_random_candy(level)
	rewards.push_back(candy)
	var texture = Shared.get_candy_texture(candy)
	var index = $RewardContainer/CandyPicker.add_item(candy.name, texture, true)
	$RewardContainer/CandyPicker.set_item_tooltip(index, Shared.get_candy_tooltip(candy))
	$RewardContainer/CandyPicker.set_item_tooltip_enabled(index, true)

func show_rewards():
	$RewardContainer.show()


func _on_candy_picker_item_selected(index: int) -> void:
	var selected_reward_candy = rewards[index]
	player_ref.basket.push_back(selected_reward_candy)
	finish()


const ENEMY_PAIRINGS: Array[Array] = [
	[{"health": 10, "attack": 2}],
	[{"health": 20, "attack": 2}, {"health": 20, "attack": 2}],
	[{"health": 30, "attack": 1}, {"health": 10, "attack": 3}, {"health": 10, "attack": 3}],
	[{"health": 20, "attack": 2}, {"health": 20, "attack": 2}, {"health": 20, "attack": 1}, {"health": 20, "attack": 1}],
	[{"health": 40, "attack": 4}],
]


const ENEMY_TEXTURES = [
	"res://art/ghost.png",
	"res://art/skeleton.png",
	"res://art/spiderman.png",
	"res://art/pumpkin head.png",
	"res://art/cat.png",
]

const BOSS_ENEMY_PAIRING = [{"health": 80, "attack": 8}]
const BOSS_ENEMY_PAIRING_TEXTURE = "res://art/boss.png"
