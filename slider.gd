extends Control

signal change(value: float)

func _on_h_slider_value_changed(value: float) -> void:
	change.emit(value)
