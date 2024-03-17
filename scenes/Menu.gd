extends Control

@export var first_level: PackedScene

@onready var select_sound: AudioStreamPlayer = $Select
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound
@onready var title = $Title
@onready var game_over = $GameOver

var game: Node

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
		game_over.hide()

		game = first_level.instantiate()
		add_child(game)

func player_died():
	game_over_sound.play()
	started = false
	game_over.show()
	game.queue_free()
