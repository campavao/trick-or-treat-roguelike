extends Node2D

signal finish()
signal house_selected()
signal friends_house_selected()
signal rich_house_selected()
signal boss_selected()

var houses_beaten: Dictionary = {}

func is_house_beaten(house_name) -> bool:
	if houses_beaten.has(house_name):
		return true

	houses_beaten[house_name] = true
	return false

func _on_house_1_pressed() -> void:
	var is_beat = is_house_beaten('house_1')
	if is_beat:
		return

	house_selected.emit()
	$"House 2".disabled = false


func _on_house_2_pressed() -> void:
	var is_beat = is_house_beaten('house_2')
	if is_beat:
		return

	friends_house_selected.emit()
	$"House 3".disabled = false


func _on_house_3_pressed() -> void:
	var is_beat = is_house_beaten('house_3')
	if is_beat:
		return
	rich_house_selected.emit()
	$"House 4".disabled = false


func _on_house_4_pressed() -> void:
	var is_beat = is_house_beaten('house_4')
	if is_beat:
		return

	house_selected.emit()
	$"House 5".disabled = false
	$"House 6".disabled = false


func _on_house_5_pressed() -> void:
	var is_beat = is_house_beaten('house_5')
	if is_beat:
		return

	house_selected.emit()
	$"House 7".disabled = false

	# disable other route
	$"House 6".disabled = true


func _on_house_6_pressed() -> void:
	var is_beat = is_house_beaten('house_6')
	if is_beat:
		return

	rich_house_selected.emit()
	$"House 9".disabled = false

	# disable other route
	$"House 5".disabled = true


func _on_house_7_pressed() -> void:
	var is_beat = is_house_beaten('house_7')
	if is_beat:
		return

	friends_house_selected.emit()
	$"House 8".disabled = false


func _on_house_8_pressed() -> void:
	var is_beat = is_house_beaten('house_8')
	if is_beat:
		return

	house_selected.emit()
	$"House 9".disabled = false


func _on_house_9_pressed() -> void:
	var is_beat = is_house_beaten('house_9')
	if is_beat:
		return

	friends_house_selected.emit()
	$"House 10".disabled = false


func _on_house_10_pressed() -> void:
	var is_beat = is_house_beaten('house_10')
	if is_beat:
		return

	house_selected.emit()
	$"House 11".disabled = false
	$"House 13".disabled = false


func _on_house_11_pressed() -> void:
	var is_beat = is_house_beaten('house_11')
	if is_beat:
		return

	house_selected.emit()
	$"House 12".disabled = false

	# disable other route
	$"House 13".disabled = true


func _on_house_12_pressed() -> void:
	var is_beat = is_house_beaten('house_12')
	if is_beat:
		return

	rich_house_selected.emit()
	$"House 15".disabled = false


func _on_house_13_pressed() -> void:
	var is_beat = is_house_beaten('house_13')
	if is_beat:
		return

	friends_house_selected.emit()
	$"House 14".disabled = false

	# disable other route
	$"House 11".disabled = true


func _on_house_14_pressed() -> void:
	var is_beat = is_house_beaten('house_14')
	if is_beat:
		return

	house_selected.emit()
	$"House 16".disabled = false


func _on_house_15_pressed() -> void:
	var is_beat = is_house_beaten('house_15')
	if is_beat:
		return

	friends_house_selected.emit()
	$"House 16".disabled = false


func _on_house_16_pressed() -> void:
	var is_beat = is_house_beaten('house_16')
	if is_beat:
		return

	house_selected.emit()
	$"House 17".disabled = false


func _on_house_17_pressed() -> void:
	var is_beat = is_house_beaten('house_17')
	if is_beat:
		return

	house_selected.emit()
	$"House 18".disabled = false


func _on_house_18_pressed() -> void:
	var is_beat = is_house_beaten('house_18')
	if is_beat:
		return

	rich_house_selected.emit()
	$"House 19".disabled = false

func _on_house_19_pressed() -> void:
	var is_beat = is_house_beaten('house_19')
	if is_beat:
		return

	house_selected.emit()
	$"House 20".disabled = false


func _on_house_20_pressed() -> void:
	var is_beat = is_house_beaten('house_20')
	if is_beat:
		return

	house_selected.emit()
	$"House 21".disabled = false


func _on_house_21_pressed() -> void:
	var is_beat = is_house_beaten('house_21')
	if is_beat:
		return

	friends_house_selected.emit()
	$"Boss House".disabled = false


func _on_boss_house_pressed() -> void:
	boss_selected.emit()

const DONT_DISABLE_CHILDREN = ['Home', 'House 1', 'Map']

func start():
	houses_beaten = {}

	for child in get_children():
		if not DONT_DISABLE_CHILDREN.has(child.name):
			child.disabled = true

	show()
