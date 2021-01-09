extends TileMap

onready var occupied = $ocupied
onready var empty_id = occupied.tile_set.find_tile_by_name("empty")

func _ready():
	for i in get_used_cells():
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
