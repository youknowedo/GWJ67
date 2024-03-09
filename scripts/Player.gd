extends Area2D
class_name Player

signal player_move
signal health_changed
signal player_died

@onready var ray = $RayCast2D
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

const TILE_SIZE = 16

var crawl_speed = 6.0
var max_health = 100
var health = max_health

var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var is_moving = false
var percent_moved_to_next_tile = 0.0
var host_active = false
var host: Host = null
var exit_host = false

func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE / 2
	initial_position = position
	health_changed.emit(health, 0)

func _physics_process(delta):
	if Input.is_action_pressed("secondary")&&host&&host_active:
		exit_host = true
	if is_moving == false:
		process_player_movement_input()
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Crawl")
		move(delta)
	else:
		anim_state.travel("Idle")
		is_moving = false

func process_player_movement_input():
	if exit_host:
		host = null
		host_active = false
		ray.set_collision_mask_value(1, false)
		input_direction = anim_tree.get("parameters/Idle/blend_position")
		health_changed.emit(health, 0)
		exit_host = false
	else:
		if input_direction.y == 0:
			input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		if input_direction.x == 0:
			input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	input_direction.normalized()

	ray.target_position = input_direction * TILE_SIZE
	ray.force_raycast_update()
	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Crawl/blend_position", input_direction)

		if !ray.is_colliding():
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

func _on_body_entered(area: Host):
	if host == null:
		host = area
		ray.set_collision_mask_value(1, true)
		health_changed.emit(health, host.health)

func _on_health_timer_timeout():
	if host&&health < max_health:
		host.health -= 2
		health += 10
		if health > max_health:
			health = max_health
		health_changed.emit(health, host.health)
	elif !host:
		health -= 10
		health_changed.emit(health, 0)

		if health <= 0:
			player_died.emit()
