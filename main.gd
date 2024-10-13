extends Node2D

const Characters = Shared.Characters

var player: Player

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
func _on_trick_complete() -> void:
	$"First Neighborhood".show()


func _on_treat_complete() -> void:
	$"First Neighborhood".show()


func _on_friends_house_complete() -> void:
	$"First Neighborhood".show()


func _on_boss_complete() -> void:
	$"First Neighborhood".hide()
	$Finish.enable(true, player.character)

# House selected
func _on_first_neighborhood_house_selected(houses_beaten: Dictionary) -> void:
	if player.skip_next_house:
		player.skip_next_house = false
		return
		
	var is_trick = randi_range(0, 1)
	if is_trick == 1:
		var easy = houses_beaten.has('house_3')
		var medium = houses_beaten.has('house_10')
		var max_amount_of_enemies = 4 if medium else 3 if easy else 2
		$Trick.enable(player, Shared.HOUSE_TYPE.NORMAL, max_amount_of_enemies)
	else:
		$Treat.enable(player, Shared.HOUSE_TYPE.NORMAL)

	$"First Neighborhood".hide()

func _on_first_neighborhood_rich_house_selected(houses_beaten: Dictionary) -> void:
	if player.skip_next_house:
		player.skip_next_house = false
		return
		
	var is_trick = randi_range(0, 1)
	if is_trick == 1:
		var easy = houses_beaten.has('house_3')
		var medium = houses_beaten.has('house_10')
		var max_amount_of_enemies = 4 if medium else 3 if easy else 2
		$Trick.enable(player, Shared.HOUSE_TYPE.RICH, max_amount_of_enemies)
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
	$Boss.enable(player)
	$"First Neighborhood".hide()

func _process(_delta):
	if player == null or $Finish.visible:
		return

	if player.health <= 0:
		$Finish.enable(false, player.character)
		player = null
		$Basket.hide()
