extends Node2D

const Characters = Shared.Characters

var player: Player

func _on_start_character_select(character: Characters) -> void:
	player = Player.new({ "character": character })
	$CharacterName.text = Shared.get_character_name(character)
	$"First Neighborhood".start()

func _on_first_neighborhood_finish() -> void:
	$"First Neighborhood".hide()
	$Finish.enable(true, player.character)


func _on_finish_start_over() -> void:
	$Start.show()

# House complete
func _on_trick_complete() -> void:
	$"First Neighborhood".show()


func _on_treat_complete() -> void:
	$"First Neighborhood".show()


func _on_friends_house_complete() -> void:
	$"First Neighborhood".show()


func _on_boss_complete() -> void:
	$"First Neighborhood".show()

# House selected
func _on_first_neighborhood_house_selected() -> void:
	$Trick.enable(player, Shared.HOUSE_TYPE.NORMAL)
	$"First Neighborhood".hide()


func _on_first_neighborhood_rich_house_selected() -> void:
	$Treat.enable(player, Shared.HOUSE_TYPE.RICH)
	$"First Neighborhood".hide()

func _on_first_neighborhood_friends_house_selected() -> void:
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
