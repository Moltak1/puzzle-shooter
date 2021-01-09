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
