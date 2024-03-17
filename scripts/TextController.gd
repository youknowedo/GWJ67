extends Sprite2D
class_name TextController

@export var text: Text
@export var player: Player

@onready var select: AudioStreamPlayer = $Select

var text_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func show_text(_text: String):
	show()
	text.change_text(_text)
	text_up = true

func _process(delta):
	if text_up&&Input.is_action_just_pressed("primary"):
		select.play()
		hide()
		text_up = false