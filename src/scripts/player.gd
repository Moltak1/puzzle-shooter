extends Node2D

signal moves_remaining
signal attack_done

enum States {
	IDLE,
	MOVE,
	ATTACK,
	MOVING,
}

const GRID_SIZE = 16
const SPEED = 100
const MAX_GRID = Vector2(20,15)
const MIN_GRID = Vector2(0,0)

var state = States.MOVE
var move_turns = 4
var move = Vector2.ZERO
var grid_pos = Vector2.ZERO
var attack = false
var target_pos = Vector2.ZERO
var last_pos = Vector2.ZERO

var move_turn_sprite := Sprite.new()
var tilemap := TileMap.new()

func _ready():
	tilemap.tile_set = TileSet.new()
	grid_pos = position / GRID_SIZE
	
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
	if "empty" in tile_name:
		if grid_pos.x + move.x >= MIN_GRID.x and grid_pos.x + move.x < MAX_GRID.x and \
				grid_pos.y + move.y >= MIN_GRID.y and grid_pos.y + move.y < MAX_GRID.y:
			last_pos = grid_pos * GRID_SIZE
			grid_pos += move
			target_pos = grid_pos * GRID_SIZE
			move_turns -= 1
			emit_signal("moves_remaining",move_turns)
			state = States.MOVING
	return Vector2.ZERO
	

func check_tile(pos):
	if tilemap.get_cellv(pos) != tilemap.INVALID_CELL:
		return tilemap.tile_set.tile_get_name(tilemap.get_cellv(pos))
	return ""
