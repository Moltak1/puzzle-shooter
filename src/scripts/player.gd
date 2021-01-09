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

var state = States.MOVE
var move_turns = 4
var move = Vector2.ZERO
var grid_pos = Vector2.ZERO
var attack = false
var target_pos = Vector2.ZERO
var last_pos = Vector2.ZERO

var tilemap := TileMap.new()
var occupiedmap := TileMap.new()
var bullet = preload("res://src/scenes/bullet.tscn")
onready var sprite = $sprite

func _ready():
	tilemap.tile_set = TileSet.new()
	grid_pos = position / Globals.GRID_SIZE
	
func _process(delta):
	match state:
		States.MOVE:
			if move and move_turns:
				move = move_grid(move)
			if attack:
				state = States.ATTACK
				move = Vector2.ZERO
				
		States.ATTACK:
			sprite.play("attack")
			if move:
				state = States.IDLE
				var bullet_instance = bullet.instance()
				bullet_instance.occupiedmap = occupiedmap
				bullet_instance.direction = move
				bullet_instance.grid_pos = grid_pos
				bullet_instance.connect("bullet_done",self,"bullet_done")
				get_parent().add_child(bullet_instance)
				move = Vector2.ZERO
				attack = false
				sprite.play("default")
		States.MOVING:
			position = position.move_toward(target_pos,SPEED * delta)
			if position == target_pos:
				state = States.MOVE
				occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Player)
				emit_signal("moving_done",move_turns)

func _unhandled_input(event):
	if event.is_action_pressed("ui_left"):
		move.x = -1
	if event.is_action_pressed("ui_right"):
		move.x = 1
	if event.is_action_pressed("ui_down"):
		move.y = 1
	if event.is_action_pressed("ui_up"):
		move.y = -1
	if event.is_action_pressed("ui_accept"):
		attack = true
		
func move_grid(move):
	var tile_name = check_tile(grid_pos + move)
	if tile_name[1] == true:
		return Vector2.ZERO
	if handle_tile(tile_name[0]):
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

func bullet_done():
	move = Vector2.ZERO
	attack = false
	state = States.MOVE
	emit_signal("attack_done")

func handle_tile(tile: String):
	var splits = tile.split("_")
	var type = splits[1]
	match type:
		"normal":
			return true
		"redkey":
			tilemap.flip_cell("tile_blocked","tile_normal")
			tilemap.change_cell(grid_pos + move,"tile_nomal")
			return true
