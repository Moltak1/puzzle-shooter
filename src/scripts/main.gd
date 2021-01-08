extends Node

onready var player = $player
onready var tilemap = $TileMap

func _ready():
	player.tilemap = tilemap
