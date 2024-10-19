extends Node2D

@export var label: String
@export var texture_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y -= randf_range(10, 50)
	position.x += randf_range(-5, 5)
	$Label.text = label
	print(texture_path)
	$Sprite.texture = load(texture_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var value = 2 * delta
	position.y -= value
	modulate.a -= delta


func _on_timer_timeout() -> void:
	queue_free()
