extends Control

var level1 = preload("res://src/scenes/level1.tscn")


func _on_start_button_pressed():
	MainAudio.sfx_play("click")
	get_tree().change_scene_to(level1)


func _on_exit_button_pressed():
	MainAudio.sfx_play("click")
	get_tree().quit()


func _on_start_button_mouse_entered():
	MainAudio.sfx_play("hover")


func _on_exit_button_mouse_entered():
	MainAudio.sfx_play("hover")


func _ready():
	MainAudio.music_play()
