extends Node

var tilemap := TileMap.new()
var tiles

var directions = [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]

onready var astar = AStar2D.new()

func start():
	tiles = tilemap.get_used_cells()
	populate()
	connect_tiles()

func populate():
	for i in tiles:
		var id = get_node_id(i)
		astar.add_point(id,i)
		

func connect_tiles():
	for i in tiles:
		var id = get_node_id(i)
		for j in directions:
			var target = i + j
			var target_id = get_node_id(target)
			if target == i or not astar.has_point(target_id):
				continue
			astar.connect_points(id,target_id,true)

func get_node_id(pos):
	return pos.x + pos.y * (tilemap.get_used_rect().size.x + 5)
	

func navigate(start,end):
	var id_start = get_node_id(start)
	var id_end = get_node_id(end)
	
	if astar.has_point(id_start) and astar.has_point(id_end):
		return astar.get_point_path(id_start,id_end)
	return null

func disable(pos):
	var id = get_node_id(pos)
	if astar.has_point(id):
		astar.set_point_disabled(id)

func enable(pos):
	var id = get_node_id(pos)
	if astar.has_point(id):
		astar.set_point_disabled(id,false)
