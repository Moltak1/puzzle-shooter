extends Node2D

var points = 0
var pointsv = []

func _draw():
	for i in pointsv:
		draw_circle(i * Globals.GRID_SIZE,4,Color.black)

func debug():
	points = get_parent().get_node("nav").astar.get_points()
	for i in points:
		pointsv.append(get_parent().get_node("nav").astar.get_point_position(i))
		
	update()
