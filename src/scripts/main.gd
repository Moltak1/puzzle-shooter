extends Node

var move_turns = 4
var move_remaining_h = 16
var move_remaining_w = 8

onready var player = $player
onready var tilemap = $TileMap
onready var move_remaining = $GUI/move_remaining

func _ready():
	change_move_remaining(move_turns)
	player.tilemap = tilemap
	player.move_turns = move_turns
	player.connect("moves_remaining",self,"change_move_remaining")
	player.connect("attack_done",self,"player_attack_done")

func change_move_remaining(moves):
	move_remaining.texture.region.position.x = moves * move_remaining_w

func player_attack_done():
	player.move_turns = move_turns
	change_move_remaining(move_turns)
