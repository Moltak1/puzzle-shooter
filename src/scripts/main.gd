extends Node

export var turns = 40
var move_remaining_h = 55
var move_remaining_w = 57
var move_remaining_max = 48
var move_remaining_count = 0
var moves_ratio = 1

onready var player = $player
onready var tilemap = $TileMap
onready var move_remaining = $GUI/move_remaining
onready var nav = $nav

func _ready():
	moves_ratio = float(move_remaining_max) / turns
	nav.tilemap = tilemap
	nav.start()
	for raised in tilemap.get_cells("tile_raised"):
		nav.disable(raised)
	change_move_remaining(turns)
	player.tilemap = tilemap
	player.occupiedmap = tilemap.occupied
	player.turns = turns
	player.nav = nav
	player.connect("player_turn_done",self,"player_turn_done")
	player.connect("exit_level",self,"exit_level")
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.tilemap = tilemap
		enemy.occupiedmap = tilemap.occupied
		enemy.nav = nav
		enemy.player = player
		enemy.connect("attacked_player",self,"attacked_player")
	$debug.debug()


func player_turn_done(moves):
	change_move_remaining(moves)
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.turn()
		yield(enemy,"done_moving")
	player.state = player.States.MOVE
	

func change_move_remaining(moves):
	move_remaining_count = round(moves * moves_ratio)
	move_remaining.texture.region.position.x = (move_remaining_max - move_remaining_count) * move_remaining_w

func attacked_player():
	print("player dies here")


func exit_level():
	get_tree().quit()
