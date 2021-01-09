extends Node

const GRID_SIZE = 16

var occupied_ids

func tile_name(tname : String):
	var split = tname.split("_")
	print(split)
	split.remove(0)
	return split
