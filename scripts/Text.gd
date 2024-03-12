extends Control
class_name Text

const CHARACTERS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ()!?.,"/- '

var TextCharacter = preload ("res://prefabs/TextCharacter.tscn")

@export_multiline var text = "Hello, World!"

func _ready():
	update()

func update():
	for c in get_children():
		remove_child(c)
		c.queue_free()

	for w in text.to_upper().split("\n"):
		var word = HBoxContainer.new()
		add_child(word)
		for c in w:
			var character: Control = TextCharacter.instantiate()
			character.custom_minimum_size = Vector2(1, 1)
			character.get_node("Sprite2D").frame_coords = Vector2(CHARACTERS.find(c), 0)
			word.add_child(character)

func change_text(new_text: String):
	text = new_text
	update()