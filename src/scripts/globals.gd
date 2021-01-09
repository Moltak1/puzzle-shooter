extends Node

const GRID_SIZE = 16
const GRID_OFFSET = Vector2(GRID_SIZE/2,GRID_SIZE/2)

var occupied_ids

func tile_name(tname : String):
	var split = tname.split("_")
	print(split)
	split.remove(0)
	return split
