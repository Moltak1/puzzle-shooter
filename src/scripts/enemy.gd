extends Node2D


signal attacked_player
signal done_moving

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

onready var sprite = $AnimatedSprite
onready var sound = $enemySound

func _ready():
	add_to_group("Enemies")
	grid_pos = position / Globals.GRID_SIZE
	target_pos = grid_pos * Globals.GRID_SIZE

func _process(delta):
	match state:
		States.MOVE:
			if move:
				move = move_grid(move)
		States.ATTACK:
			sprite.play("attack")
		States.MOVING:
			emit_signal("done_moving")
			position = position.move_toward(target_pos,SPEED * delta)
			if position == target_pos:
				sprite.play("default")
				state = States.ATTACK if attack else States.IDLE

func move_grid(move):
	var tile_status = check_tile(grid_pos + move)
	if tile_status[1] == false:
		sound.play_sound("walk")
		last_pos = grid_pos * Globals.GRID_SIZE
		occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Empty)
		nav.enable(grid_pos)
		grid_pos += move
		occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Enemy)
		nav.disable(grid_pos)
		sprite.play("walk")
		target_pos = grid_pos * Globals.GRID_SIZE
	state = States.MOVING
	return Vector2.ZERO
	

func check_tile(pos):
	if tilemap.get_cellv(pos) != tilemap.INVALID_CELL and occupiedmap.get_cellv(pos) != -1:
		var occupied = occupiedmap.tile_set.tile_get_name(occupiedmap.get_cellv(pos)) != "empty"
		return [tilemap.tile_set.tile_get_name(tilemap.get_cellv(pos)),occupied]
	return ["",true]

func turn():
	if state == States.IDLE:
		var navigation = nav.navigate(grid_pos,player.grid_pos)
		if navigation:
			state = States.MOVE
			move = navigation[1] - grid_pos
			if navigation.size() <= 3:
				attack = true
		else:
			state = States.MOVING

func die():
	sound.play_sound("die")
	sprite.play("dead")
	set_process(false)


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "dead":
		sprite.play("splatter")
	elif sprite.animation == "splatter":
		occupiedmap.set_cellv(grid_pos,Globals.occupied_ids.Empty)
		nav.enable(grid_pos)
		emit_signal("done_moving")
		queue_free()
	elif sprite.animation == "attack":
		emit_signal("attacked_player")
