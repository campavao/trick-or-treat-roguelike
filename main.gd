extends Node2D

const Characters = Shared.Characters

enum HouseType {
	Treat,
	Trick,
}

var player: Player
var trick_or_treat_tracker: Array[HouseType] = []

func _on_start_character_select(character: Characters) -> void:
	player = Player.new({ "character": character })
	$CharacterName.text = Shared.get_character_name(character)
	$"First Neighborhood".start()
	$Basket.player = player
	$Basket.show()

func _on_first_neighborhood_finish() -> void:
	$"First Neighborhood".hide()
	$Finish.enable(true, player.character)


func _on_finish_start_over() -> void:
	$Start.show()
	$Basket.hide()

# House complete
func _on_trick_complete(is_boss_house: bool) -> void:
	if is_boss_house:
		$Finish.enable(true, player.character)
	else:
		$"First Neighborhood".show()


func _on_treat_complete() -> void:
	# if trigger_fight, we don't want to show the neighborhood again
	if $Trick.visible:
		return

	$"First Neighborhood".show()


func _on_friends_house_complete() -> void:
	$"First Neighborhood".show()


func _on_boss_complete() -> void:
	$"First Neighborhood".hide()
	$Finish.enable(true, player.character)

# House selected
func _on_first_neighborhood_house_selected() -> void:
	if player.skip_next_house:
		player.skip_next_house = false
		return

	var type = get_trick_or_treat()
	if type == HouseType.Trick:
		enable_trick(Shared.HOUSE_TYPE.NORMAL)
	else:
		$Treat.enable(player, Shared.HOUSE_TYPE.NORMAL)

	$"First Neighborhood".hide()

func _on_first_neighborhood_rich_house_selected() -> void:
	if player.skip_next_house:
		player.skip_next_house = false
		return

	var type = get_trick_or_treat()
	if type == HouseType.Trick:
		enable_trick(Shared.HOUSE_TYPE.RICH)
	else:
		$Treat.enable(player, Shared.HOUSE_TYPE.RICH)

	$"First Neighborhood".hide()

func _on_first_neighborhood_friends_house_selected() -> void:
	if player.skip_next_house:
		player.skip_next_house = false
		return

	$FriendsHouse.enable(player)
	$"First Neighborhood".hide()

func _on_first_neighborhood_boss_selected() -> void:
	$Trick.base_health = 40
	$Trick.enable(player, Shared.HOUSE_TYPE.BOSS, 1, 1)

	# $Boss.enable(player)
	$"First Neighborhood".hide()

func _process(_delta):
	if player == null or $Finish.visible:
		return

	if player.health <= 0:
		$Finish.enable(false, player.character)
		player = null
		$Basket.hide()

func get_trick_or_treat() -> HouseType:
	var last_three = trick_or_treat_tracker.slice(0, 3)
	var first = last_three.front()
	print(first, " ", last_three)
	if first != null and last_three.size() == 3:
		var is_all_same = last_three.all(func(element): return element == first)
		print(is_all_same)
		if is_all_same:
			match first:
				HouseType.Trick:
					trick_or_treat_tracker.push_front(HouseType.Treat)
					return HouseType.Treat
				HouseType.Treat:
					trick_or_treat_tracker.push_front(HouseType.Trick)
					return HouseType.Trick

	var is_trick = randf_range(0.0, 1.0)
	if is_trick > 0.25:
		trick_or_treat_tracker.push_front(HouseType.Trick)
		return HouseType.Trick

	trick_or_treat_tracker.push_front(HouseType.Treat)
	return HouseType.Treat



func _on_treat_trigger_fight(type: Shared.HOUSE_TYPE) -> void:
	$"First Neighborhood".hide()
	enable_trick(type)

func enable_trick(type: Shared.HOUSE_TYPE):
	var houses_beaten = $"First Neighborhood".houses_beaten
	var easy = houses_beaten.has('house_3')
	var medium = houses_beaten.has('house_10')
	var max_amount_of_enemies = 4 if medium else 3 if easy else 2
	var difficulty_multiplier = 2 if medium else 1
	$Trick.enable(player, type, max_amount_of_enemies, difficulty_multiplier, !houses_beaten.has('house_1'))
