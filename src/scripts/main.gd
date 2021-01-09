extends Node

var turns = 15
var move_remaining_h = 16
var move_remaining_w = 8

onready var player = $player
onready var tilemap = $TileMap
onready var move_remaining = $GUI/move_remaining
onready var nav = $nav

func _ready():
	nav.tilemap = tilemap
	nav.start()
	for raised in tilemap.get_cells("tile_raised"):
		nav.disable(raised)
	change_move_remaining(turns)
	player.tilemap = tilemap
	player.occupiedmap = tilemap.occupied
	player.turns = turns
	player.nav = nav
	player.connect("moving_done",self,"player_done_moving")
	player.connect("attack_done",self,"player_attack_done")
	player.connect("exit_level",self,"exit_level")
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.tilemap = tilemap
		enemy.occupiedmap = tilemap.occupied
		enemy.nav = nav
		enemy.player = player
		enemy.connect("attacked_player",self,"attacked_player")
	$debug.debug()

func player_done_moving(moves):
	change_move_remaining(moves)
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.turn()

func player_attack_done():
	player.turns = turns
	change_move_remaining(turns)

func change_move_remaining(moves):
	move_remaining.texture.region.position.x = moves * move_remaining_w

func attacked_player():
	print("player dies here")


func exit_level():
	get_tree().quit()
