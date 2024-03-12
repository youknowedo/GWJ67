extends Node2D

@export var game_controller: GameController
@onready var continue_area: Area2D = $Continue
@onready var back_area: Area2D = $Back

var continue_to_next = false
var back_to_previous = false

func _on_continue_area_entered(area: Area2D):
	if !back_to_previous&&area is Player:
		continue_to_next = true
		game_controller.next_room()

func _on_continue_area_exited(area: Area2D):
	if area is Player:
		continue_to_next = false

func _on_back_area_entered(area: Area2D):
	if !continue_to_next&&area is Player:
		back_to_previous = true
		game_controller.previous_room()

func _on_back_area_exited(area: Area2D):
	if area is Player:
		back_to_previous = false
