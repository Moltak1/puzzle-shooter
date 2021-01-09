extends Node2D


signal attacked_player

enum States {
	IDLE,
	MOVE,
	ATTACK,
	MOVING,
}

const SPEED = 100

var state = States.IDLE
var move = Vector2.ZERO
var grid_pos = Vector2.ZERO
var attack = false
var target_pos = Vector2.ZERO
var last_pos = Vector2.ZERO

var tilemap := TileMap.new()
var occupiedmap := TileMap.new()
var player := Node2D.new()
var nav := Node.new()

func _ready():
	add_to_group("Enemies")
	grid_pos = position / Globals.GRID_SIZE

func _process(delta):
	match state:
		States.MOVE:
			if move:
				move = move_grid(move)
		States.ATTACK:
			emit_signal("attacked_player")
			queue_free()
		States.MOVING:
			position = position.move_toward(target_pos,SPEED * delta)
			if position == target_pos:
				occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Enemy)
				nav.disable(grid_pos)
				state = States.ATTACK if attack else States.IDLE

func move_grid(move):
	var tile_status = check_tile(grid_pos + move)
	if tile_status[1] == false:
		last_pos = grid_pos * Globals.GRID_SIZE
		occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Empty)
		nav.enable(grid_pos)
		grid_pos += move
		target_pos = grid_pos * Globals.GRID_SIZE
	state = States.MOVING
	return Vector2.ZERO
	

func check_tile(pos):
	if tilemap.get_cellv(pos) != tilemap.INVALID_CELL:
		var occupied = occupiedmap.tile_set.tile_get_name(occupiedmap.get_cellv(pos)) != "empty"
		return [tilemap.tile_set.tile_get_name(tilemap.get_cellv(pos)),occupied]
	return ["",true]

func turn():
	if state == States.IDLE:
		state = States.MOVE
		var navigation = nav.navigate(grid_pos,player.grid_pos)
		print(navigation)
		if navigation:
			move = navigation[1] - grid_pos
			if navigation.size() < 3:
				attack = true

func die():
	occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Empty)
	nav.enable(grid_pos)
	queue_free()
