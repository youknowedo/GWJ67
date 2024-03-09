extends Area2D
class_name Player

signal player_move

@onready var ray = $RayCast2D
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

const TILE_SIZE = 16

@export var crawl_speed = 6.0
var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var is_moving = false
var percent_moved_to_next_tile = 0.0
var host_active = false
var host: Hostable = null

func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE / 2
	initial_position = position

func _physics_process(delta):
	if is_moving == false:
		process_player_movement_input()
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Crawl")
		move(delta)
	else:
		anim_state.travel("Idle")
		is_moving = false

func process_player_movement_input():
	if Input.is_action_pressed("ui_accept"):
		host = null
		host_active = false
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	input_direction.normalized()

	ray.target_position = input_direction * TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding()&&input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Crawl/blend_position", input_direction)
		initial_position = position
		is_moving = true
	else:
		anim_state.travel("Idle")

func move(delta):
	percent_moved_to_next_tile += crawl_speed * delta
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		if host:
			host_active = true
	else:
		position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)

	player_move.emit(position, input_direction)
	if host&&host_active:
		host.position = position

func _on_area_entered(area: Hostable):
	host = area
