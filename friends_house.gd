extends Node2D

signal complete()

func enable(state: Player):
	show()

func _on_button_pressed() -> void:
	hide()
	complete.emit()
