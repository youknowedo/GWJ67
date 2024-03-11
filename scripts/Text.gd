extends Control

const CHARACTERS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ()!?.,"/- '

var TextCharacter = preload ("res://prefabs/TextCharacter.tscn")

@export_multiline var text = "Hello, World!"

func _ready():
	update()

func update():
	for c in get_children():
		remove_child(c)
		c.queue_free()

	for c in text.to_upper():
		var character: Control = TextCharacter.instantiate()
		character.custom_minimum_size = Vector2(1, 0)
		character.get_node("Sprite2D").frame_coords = Vector2(CHARACTERS.find(c), 0)
		add_child(character)
