extends Node2D

@export var game_controller: GameController
@onready var continue_area: Area2D = $Continue
@onready var back_area: Area2D = $Back

var action = ""
var inside_other = false

func _on_continue_area_entered(area: Area2D):
	if area is Player:
		if action == "":
			action = "continue"
		else:
			inside_other = true
func _on_continue_area_exited(area: Area2D):
	if area is Player:
		if action == "continue":
			if inside_other:
				game_controller.next_room()
			action = ""
		else:
			inside_other = false

func _on_back_area_entered(area: Area2D):
	if area is Player:
		if action == "":
			action = "back"
		else:
			inside_other = true

func _on_back_area_exited(area: Area2D):
	if area is Player:
		if action == "back":
			if inside_other:
				game_controller.previous_room()
			action = ""
		else:
			inside_other = false
