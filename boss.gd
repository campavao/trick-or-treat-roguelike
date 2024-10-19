extends Node2D

signal start()
signal end_early()

func enable(_state: Player):
	show()

func _on_button_pressed() -> void:
	hide()
	start.emit()


func _on_take_1_candy_pressed() -> void:
	hide()
	end_early.emit()
