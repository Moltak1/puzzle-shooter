extends AudioStreamPlayer

var walk = [
	preload("res://assets/sounds/enemy_walk1.wav"),
	preload("res://assets/sounds/enemy_walk2.wav"),
	preload("res://assets/sounds/enemy_walk3.wav"),
]

var die = preload("res://assets/sounds/enemy_die.ogg")

func play_sound(sound):
	match sound:
		"die":
			stream = die
			play()
		"walk":
			stream = walk[randi() % walk.size()]
			play()
		
