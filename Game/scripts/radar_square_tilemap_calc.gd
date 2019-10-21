extends Node2D

export(NodePath) var tilemap

func _ready():
	if tilemap:
		tilemap = get_node(tilemap)
		if tilemap is TileMap:
			var area_sizse = tilemap.cell_size * tilemap.get_used_rect().size
			get_parent().area_size = area_sizse
	queue_free()