extends Node2D

signal complete()

func enable(state: Player, type: Shared.HOUSE_TYPE):
	show()
	# Setup enemy
	# Setup player
	# Start player turn


func _on_button_pressed() -> void:
	hide()
	complete.emit()
