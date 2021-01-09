extends Node2D

signal attack_done
signal moving_done

enum States {
	IDLE,
	MOVE,
	ATTACK,
	MOVING,
}

const SPEED = 100

var max_grid = Vector2(20,15)
var min_grid = Vector2(0,0)
var state = States.MOVE
var move_turns = 4
var move = Vector2.ZERO
var grid_pos = Vector2.ZERO
var attack = false
var target_pos = Vector2.ZERO
var last_pos = Vector2.ZERO

var tilemap := TileMap.new()
var occupiedmap := TileMap.new()

func _ready():
	tilemap.tile_set = TileSet.new()
	grid_pos = position / Globals.GRID_SIZE
	
func _process(delta):
	match state:
		States.MOVE:
			if move and move_turns:
				move = move_grid(move)
		States.ATTACK:
			if attack:
				state = States.MOVE
				move = Vector2.ZERO
				attack = false
				emit_signal("attack_done")
		States.MOVING:
			position = position.move_toward(target_pos,SPEED * delta)
			if position == target_pos:
				state = States.MOVE
				occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Player)
				emit_signal("moving_done",move_turns)
				if move_turns == 0:
					state = States.ATTACK

func _unhandled_input(event):
	if event.is_action_pressed("ui_left"):
		move.x = -1
	if event.is_action_pressed("ui_right"):
		move.x = 1
	if event.is_action_pressed("ui_down"):
		move.y = 1
	if event.is_action_pressed("ui_up"):
		move.y = -1
	if event.is_action_pressed("ui_accept") and state == States.ATTACK:
		attack = true
		
func move_grid(move):
	var tile_name = check_tile(grid_pos + move)
	if tile_name[1] == true:
		return Vector2.ZERO
	if "normal" in tile_name[0]:
		if grid_pos.x + move.x >= min_grid.x and grid_pos.x + move.x < max_grid.x and \
				grid_pos.y + move.y >= min_grid.y and grid_pos.y + move.y < max_grid.y:
			last_pos = grid_pos * Globals.GRID_SIZE
			occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Empty)
			grid_pos += move
			target_pos = grid_pos * Globals.GRID_SIZE
			move_turns -= 1
			state = States.MOVING
	return Vector2.ZERO
	

func check_tile(pos):
	if tilemap.get_cellv(pos) != tilemap.INVALID_CELL:
		var occupied = occupiedmap.tile_set.tile_get_name(occupiedmap.get_cellv(pos)) != "empty"
		return [tilemap.tile_set.tile_get_name(tilemap.get_cellv(pos)),occupied]
	return ["",true]

