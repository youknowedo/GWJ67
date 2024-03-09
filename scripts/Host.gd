extends CharacterBody2D
class_name Host

const TILE_SIZE = 16

func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE / 2
