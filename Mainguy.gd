extends Area2D

var tile_size = 128

func _ready():
	set_process_input(true)
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2

func _input(_event):
	if Input.is_action_pressed("ui_up"):
		position.y -= tile_size
	if Input.is_action_pressed("ui_down"):
		position.y += tile_size
	if Input.is_action_pressed("ui_left"):
		position.x -= tile_size
	if Input.is_action_pressed("ui_right"):
		position.x += tile_size