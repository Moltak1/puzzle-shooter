extends Node

#TURNS HAVE TO BE MULTIPLE OF 8 max of 72
var move_remaining_h = 64
var move_remaining_w = 64
var move_remaining_count = 0

onready var player = $player
onready var tilemap = $TileMap
onready var orb_wheel = $GUI/orb_wheel
onready var orb_bar = $GUI/orb_bar
onready var nav = $nav

export(int, 1, 72) var turns = 72
export(PackedScene) var next_level

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
	player.connect("player_turn_done",self,"player_turn_done")
	player.connect("exit_level",self,"exit_level")
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.tilemap = tilemap
		enemy.occupiedmap = tilemap.occupied
		enemy.nav = nav
		enemy.player = player
		enemy.connect("attacked_player",self,"attacked_player")
		tilemap.occupied.set_cellv(enemy.grid_pos,Globals.occupied_ids.Enemy)
		nav.disable(enemy.grid_pos)
	$debug.debug()


func player_turn_done(moves):
	change_move_remaining(moves)
	if moves == 0:
		$GUI/deadBackground.show()
		$GUI/deadBackground/outOfMoves.show()
		player.set_process(false)
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.turn()
		yield(enemy,"done_moving")
	player.state = player.States.MOVE
	

func change_move_remaining(moves):
	var bar_moves = (moves - 1) / 8
	var orb_moves = moves - 8 * bar_moves
	print(moves)
	orb_wheel.texture.region.position.x = orb_moves * move_remaining_w
	orb_bar.texture.region.position.x = bar_moves * move_remaining_w

func attacked_player():
	player.die()
	yield(player,("p_died"))
	$GUI/deadBackground.show()
	$GUI/deadBackground/youDied.show()
	player.set_process(false)


func exit_level():
	if next_level:
		get_tree().change_scene_to(next_level)
	else:
		get_tree().quit()


func _on_restart_button_pressed():
	MainAudio.sfx_play("click")
	get_tree().reload_current_scene()


func _on_restartButton_mouse_entered():
	MainAudio.sfx_play("hover")
