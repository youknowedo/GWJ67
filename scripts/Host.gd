extends CharacterBody2D
class_name Host

const TILE_SIZE = 16

@export var max_health = 100
var health = max_health

func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE / 2
