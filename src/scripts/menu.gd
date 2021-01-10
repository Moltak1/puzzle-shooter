extends Control

var level1 = preload("res://src/scenes/level1.tscn")

func _on_start_button_pressed():
	get_tree().change_scene_to(level1)


func _on_exit_button_pressed():
	get_tree().quit()
