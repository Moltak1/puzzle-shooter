extends Node2D

signal player_turn_done
signal exit_level
signal p_died

enum States {
	IDLE,
	MOVE,
	ATTACK,
	MOVING,
}

const SPEED = 100

var state = States.MOVE
var turns = 4
var move = Vector2.ZERO
var grid_pos = Vector2.ZERO
var attack = false
var target_pos = Vector2.ZERO
var last_pos = Vector2.ZERO
var has_gun = false
var has_key = false
var exit = false

var tilemap := TileMap.new()
var occupiedmap := TileMap.new()
var nav := Node.new()
var bullet = preload("res://src/scenes/bullet.tscn")
onready var sprite = $sprite
onready var player_sound = $playerSound

func _ready():
	tilemap.tile_set = TileSet.new()
	grid_pos = position / Globals.GRID_SIZE
	
func _process(delta):
	match state:
		States.MOVE:
			if move:
				move = move_grid(move)
			if attack:
				state = States.ATTACK
				move = Vector2.ZERO
				
		States.ATTACK:
			sprite.play("attack_ready")
			if move:
				state = States.IDLE
				var bullet_instance = bullet.instance()
				bullet_instance.occupiedmap = occupiedmap
				bullet_instance.direction = move
				bullet_instance.grid_pos = grid_pos
				bullet_instance.connect("bullet_done",self,"bullet_done")
				get_parent().add_child(bullet_instance)
				sprite.play("attack_fire")
				
		States.MOVING:
			position = position.move_toward(target_pos,SPEED * delta)
			if position == target_pos:
				if exit:
					emit_signal("exit_level")
				else:
					state = States.IDLE
					occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Player)
					emit_signal("player_turn_done",turns)

func _unhandled_input(event):
	move = Vector2.ZERO
	if event.is_action_pressed("move_left"):
		sprite.flip_h = false
		move.x = -1
	if event.is_action_pressed("move_right"):
		sprite.flip_h = true
		move.x = 1
	if event.is_action_pressed("move_down"):
		move.y = 1
	if event.is_action_pressed("move_up"):
		move.y = -1
	if event.is_action_pressed("attack") and has_gun:
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
		turns -= 1
		sprite.play("walk")
		if move == Vector2.UP:
			sprite.play("walk_up")
		elif move == Vector2.DOWN:
			sprite.play("walk_down")
		state = States.MOVING
	return Vector2.ZERO
	

func check_tile(pos):
	if tilemap.get_cellv(pos) != tilemap.INVALID_CELL and occupiedmap.get_cellv(pos) != -1:
		var occupied = occupiedmap.tile_set.tile_get_name(occupiedmap.get_cellv(pos)) != "empty"
		return [tilemap.tile_set.tile_get_name(tilemap.get_cellv(pos)),occupied]
	return ["",true]

func bullet_done(moved):
	move = Vector2.ZERO
	attack = false
	if moved:
		turns -= 1
		sprite.play("default")
		emit_signal("player_turn_done",turns)
	else:
		state = States.ATTACK

func handle_tile(tile: String):
	var splits = tile.split("_")
	var type = splits[1]
	match type:
		"normal":
			player_sound.play_sound("walk")
			return true
		"key":
			player_sound.play_sound("keys")
			has_key = true
			clear_tile()
			return true
		"gun":
			player_sound.play_sound("gun")
			clear_tile()
			has_gun = true
			return true
		"exit":
			player_sound.play_sound("exit")
			exit = true
			return true
		"lock":
			if has_key:
				player_sound.play_sound("lower")
				clear_tile()
				tilemap.flip_cell("tile_raised","tile_lowered")
				for lowered in tilemap.get_cells("tile_lowered"):
					nav.enable(lowered)
				return true
		"lowered":
			player_sound.play_sound("walk")
			return true

func clear_tile():
	tilemap.change_cell(grid_pos + move, "tile_normal")


func _on_sprite_animation_finished():
	match sprite.animation:
		"attack_fire":
			sprite.play("attack_ready")
		"dead":
			emit_signal("p_died")
		"walk", "walk_up", "walk_down":
			sprite.play("default")

func die():
	player_sound.play_sound("die")
	sprite.play("dead")
	set_process(false)
