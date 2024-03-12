extends Node2D
class_name GameController

@export var lerp_camera: Camera2D
@export var room_cameras: Array[Camera2D] = []

@export var camera_transition_time: float = 1.0

var current_room: int = 0
var from_room: int = -1

func _ready():
	lerp_camera.enabled = false
	for camera in room_cameras:
		camera.enabled = false

	room_cameras[current_room].enabled = true

func _physics_process(delta):
	if from_room != - 1:
		lerp_camera.enabled = true
		room_cameras[from_room].enabled = false

		lerp_camera.position = room_cameras[current_room].global_position.lerp(room_cameras[from_room].global_position, delta / camera_transition_time)
		if lerp_camera.position.distance_to(room_cameras[from_room].global_position) < 0.1:
			lerp_camera.position = room_cameras[current_room].global_position
			lerp_camera.enabled = false
			room_cameras[current_room].enabled = true
			from_room = -1

func change_room(room: int) -> void:
	from_room = current_room
	current_room = room

func next_room() -> void:
	change_room((current_room + 1) % room_cameras.size())

func previous_room() -> void:
	change_room((current_room - 1) % room_cameras.size())