extends Node

var music = preload("res://assets/sounds/Draf_musict.ogg")
var hover = preload("res://assets/sounds/hover_button.wav")
var click = preload("res://assets/sounds/button_click.wav")

var sfx_controller = AudioStreamPlayer.new()
var music_controller = AudioStreamPlayer.new()

func _ready():
	add_child(sfx_controller)
	add_child(music_controller)
	sfx_controller.volume_db = -10
	
func music_play():
	music_controller.stream = music
	music_controller.volume_db = -25
	music_controller.play()

func sfx_play(sound):
	match sound:
		"hover":
			sfx_controller.stream = hover
			sfx_controller.play()
		"click":
			sfx_controller.stream = click
			sfx_controller.play()
