extends Control

var sound_is_muted: bool = false

func _ready() -> void:
	Signals.connect("play_sound", on_play_sound)

func _on_music_slider_change(value: float) -> void:
	$BGMusicPlayer.volume_db = value - 30
	if value <= 0:
		$BGMusicPlayer.stop()
	elif not $BGMusicPlayer.playing:
		$BGMusicPlayer.play()


func _on_button_toggled(toggled_on: bool) -> void:
	$Controls.visible = toggled_on


func _on_sound_slider_change(value: float) -> void:
	$SoundPlayer.volume_db = value - 30
	var is_muted = value <= 0
	sound_is_muted = is_muted
	
	if is_muted:
		$SoundPlayer.stop()
	elif not $BGMusicPlayer.playing:
		$SoundPlayer.play()

const YUM_SOUNDS = [
	preload('res://sounds/yum 1.mp3'),
	preload('res://sounds/yum 2.mp3'),
	preload('res://sounds/yum 3.mp3'),
	preload('res://sounds/yum 4.mp3'),
	preload('res://sounds/yum 5.mp3'),
	preload('res://sounds/yum 6.mp3'),
]

const HIT_SOUNDS = [
	preload('res://sounds/hit 1.mp3'),
	preload('res://sounds/hit 2.mp3'),
	preload('res://sounds/hit 3.mp3'),
	preload('res://sounds/hit 4.mp3'),
	preload('res://sounds/hit 5.mp3'),
	preload('res://sounds/hit 6.mp3'),
	preload('res://sounds/enemy hit.mp3')
]

const GRAB_SOUNDS = [
	preload('res://sounds/grab 1.mp3'),
	preload('res://sounds/grab 2.mp3'),
	preload('res://sounds/grab 3.mp3'),
	preload('res://sounds/grab 4.mp3'),
]

func on_play_sound(type: Shared.SoundType):
	if sound_is_muted:
		return
		
	match type:
		Shared.SoundType.YUM:
			var random = YUM_SOUNDS.pick_random()
			$SoundPlayer.stream = random
			$SoundPlayer.play()
		Shared.SoundType.HIT:
			var random = HIT_SOUNDS.pick_random()
			$SoundPlayer.stream = random
			$SoundPlayer.play()
		Shared.SoundType.GRAB:
			var random = GRAB_SOUNDS.pick_random()
			$SoundPlayer.stream = random
			$SoundPlayer.play()
			
