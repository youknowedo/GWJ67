extends Node2D
class_name GameController

@export var room_cameras: Array[Camera2D] = []

var current_room: int = 0

func _ready():
	for camera in room_cameras:
		camera.enabled = false

	room_cameras[current_room].enabled = true

func change_room(room: int) -> void:
	room_cameras[current_room].enabled = false
	room_cameras[room].enabled = true
	
	current_room = room

func next_room() -> void:
	change_room((current_room + 1) % room_cameras.size())

func previous_room() -> void:
	change_room((current_room - 1) % room_cameras.size())