extends TileMap

var not_walls

onready var occupied = $ocupied
onready var empty_id = occupied.tile_set.find_tile_by_name("empty")

func _ready():
	not_walls = get_not_walls()
	for i in not_walls:
		occupied.set_cellv(i,empty_id)
	Globals.occupied_ids = {
		"Empty": occupied.tile_set.find_tile_by_name("empty"),
		"Enemy": occupied.tile_set.find_tile_by_name("enemy"),
		"Player": occupied.tile_set.find_tile_by_name("player"),
	}

func flip_cell(from,to):
	var from_id = tile_set.find_tile_by_name(from)
	var to_id = tile_set.find_tile_by_name(to)
	for i in get_used_cells_by_id(from_id):
		set_cellv(i,to_id)

func change_cell(pos,type):
	var type_id = tile_set.find_tile_by_name(type)
	set_cellv(pos,type_id)

func get_cells(type):
	var type_id = tile_set.find_tile_by_name(type)
	return get_used_cells_by_id(type_id)
	
func get_not_walls():
	var all_cells = get_used_cells()
	var wall_id = tile_set.find_tile_by_name("tile_wall")
	var wall_cells = get_used_cells_by_id(wall_id)
	for i in wall_cells:
		all_cells.erase(i)
	return all_cells
