extends Node2D

signal bullet_done

const SPEED = 100
var direction = Vector2.ZERO
var grid_pos = Vector2.ZERO
var moving = false
var target_pos = Vector2.ZERO
var moved = false

var occupiedmap := TileMap.new()

func _ready():
	position = grid_pos * Globals.GRID_SIZE + Globals.GRID_OFFSET
	rotate(direction.angle())
	if check_tile(grid_pos + direction):
		moved = true
		$AudioStreamPlayer.play(0.2)
		show()

func _process(delta):
	if not moving:
		var tile = check_tile(grid_pos + direction)
		if tile == "empty":
			grid_pos += direction
			target_pos = grid_pos * Globals.GRID_SIZE + Globals.GRID_OFFSET
			moving = true
		elif tile == "enemy":
			for enemy in get_tree().get_nodes_in_group("Enemies"):
				if enemy.grid_pos == grid_pos + direction:
					enemy.die()
					emit_signal("bullet_done",moved)
					queue_free()
		else:
			emit_signal("bullet_done",moved)
			queue_free()
	position = position.move_toward(target_pos,SPEED * delta)
	if position == target_pos:
		moving = false



func check_tile(pos):
	if occupiedmap.get_cellv(pos) != occupiedmap.INVALID_CELL:
		var occupied = occupiedmap.tile_set.tile_get_name(occupiedmap.get_cellv(pos))
		return occupied
