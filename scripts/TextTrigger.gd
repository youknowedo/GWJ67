extends Area2D

@export var text_controller: TextController
@export_multiline var text: String = "Hello, World!"
@export var wait_time: float = 0.0

func _on_area_entered(_area):
	await get_tree().create_timer(wait_time).timeout
	text_controller.show_text(text)
