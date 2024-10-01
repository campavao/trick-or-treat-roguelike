extends Control

const FALLBACK_IMAGE = preload('res://art/candy/reeses_fun.png')

var state: CandyClass

func initialize(candy: CandyClass):
	state = candy
	load_texture(candy.texture_path)
	
func load_texture(path: String):
	print(path)
	var texture = load(path)
	
	if texture == null:
		texture = FALLBACK_IMAGE
		
	$Sprite2D.texture = texture
