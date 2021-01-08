extends Node2D

enum States {
	IDLE,
	MOVE,
	ATTACK,
	MOVING,
}

const GRID_SIZE = 32
const MAX_MOVE_TURNS = 4
const SPEED = 100
const MAX_GRID = Vector2(12,7)
const MIN_GRID = Vector2(3,2)

var state = States.MOVE
var move_turns = 4
var move = Vector2.ZERO
var grid_pos = Vector2.ZERO
var attack = false
var target_pos = Vector2.ZERO
var last_pos = Vector2.ZERO

onready var move_turn_sprite = $move_turn

func _ready():
	grid_pos = MIN_GRID
	position = MIN_GRID * GRID_SIZE

func _process(delta):
	update_move_turns()
	match state:
		States.MOVE:
			if move and move_turns:
				move = move_grid(move)
		States.ATTACK:
			if attack:
				state = States.MOVE
				move = Vector2.ZERO
				move_turns = MAX_MOVE_TURNS
				attack = false
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
	check_tile(grid_pos + move)
	if grid_pos.x + move.x >= MIN_GRID.x and grid_pos.x + move.x < MAX_GRID.x and \
			grid_pos.y + move.y >= MIN_GRID.y and grid_pos.y + move.y < MAX_GRID.y:
		last_pos = grid_pos * GRID_SIZE
		grid_pos += move
		target_pos = grid_pos * GRID_SIZE
		move_turns -= 1
		state = States.MOVING
	return Vector2.ZERO
	
func update_move_turns():
	move_turn_sprite.hide()
	move_turn_sprite.frame = move_turns
	if state == States.MOVE:
		move_turn_sprite.show()

func check_tile(pos):
	pass
