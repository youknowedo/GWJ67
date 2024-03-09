extends Area2D
class_name Hostable

const TILE_SIZE = 16

func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE / 2
