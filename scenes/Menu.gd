extends Control

@export var first_level: PackedScene

@onready var select_sound: AudioStreamPlayer = $Select
@onready var title = $Title

var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !started&&Input.is_action_just_pressed("primary"):
		started = true
		select_sound.play()
		title.hide()

		var first = first_level.instantiate()
		add_child(first)
