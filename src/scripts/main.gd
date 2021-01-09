extends Node

var move_turns = 4
var move_remaining_h = 16
var move_remaining_w = 8

onready var player = $player
onready var tilemap = $TileMap
onready var move_remaining = $GUI/move_remaining
onready var nav = $nav

func _ready():
	nav.tilemap = tilemap
	nav.start()
	change_move_remaining(move_turns)
	player.tilemap = tilemap
	player.occupiedmap = tilemap.occupied
	player.move_turns = move_turns
	player.connect("moving_done",self,"player_done_moving")
	player.connect("attack_done",self,"player_attack_done")
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.tilemap = tilemap
		enemy.occupiedmap = tilemap.occupied
		enemy.nav = nav
		enemy.player = player
	$debug.debug()

func player_done_moving(moves):
	change_move_remaining(moves)
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.turn()

func player_attack_done():
	player.move_turns = move_turns
	change_move_remaining(move_turns)

func change_move_remaining(moves):
	move_remaining.texture.region.position.x = moves * move_remaining_w
