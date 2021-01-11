extends AudioStreamPlayer

var walk = [
	preload("res://assets/sounds/walk1.wav"),
	preload("res://assets/sounds/walk2.wav"),
	preload("res://assets/sounds/walk3.wav"),
	preload("res://assets/sounds/walk4.wav"),
	preload("res://assets/sounds/walk5.wav"),
	preload("res://assets/sounds/walk6.wav"),
]

var keys = preload("res://assets/sounds/keys sound.ogg")
var lower = preload("res://assets/sounds/lowering sound.ogg")
var die = preload("res://assets/sounds/player_die.wav")
var gun = preload("res://assets/sounds/gun_pickup.wav")
var exit = preload("res://assets/sounds/exit.wav")

func play_sound(sound):
	volume_db = -6
	match sound:
		"keys":
			stream = keys
			play()
		"lower":
			volume_db = -3
			stream = lower
			play()
		"die":
			stream = die
			play()
		"gun":
			stream = gun
			play()
		"walk":
			stream = walk[randi() % walk.size()]
			play()
		"exit":
			stream = exit
			play(0.28)
