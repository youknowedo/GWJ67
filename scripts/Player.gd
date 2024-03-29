extends Area2D
class_name Player

signal health_changed
signal player_move
signal player_attack
signal player_died

const States = {
	IDLE = "Idle",
	WALK = "Walk",
	ATTACK = "Attack"
}

@export var text_controller: TextController

@onready var ray = $RayCast2D
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var health_timer = $HealthTimer
@onready var die = $Die
@onready var exit = $Exit

const TILE_SIZE = 16

var walk_speed = 6.0
var max_health = 100
var health = max_health

var current_state = States.IDLE
var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var look_input_direction = Vector2(0, 0)
var is_moving = false
var percent_moved_to_next_tile = 0.0
var host_active = false
var host: Host = null
var exit_host = false

func _ready():
	initial_position = position
	health_changed.emit(health, 0)

func _physics_process(delta):
	if Input.is_action_pressed("secondary")&&host&&host_active&&!text_controller.text_up:
		exit_host = true
	
	if host&&host.state != host.States.DEAD&&host.anim_state.get_current_node() != States.ATTACK&&Input.is_action_just_pressed("primary"):
		change_state(States.ATTACK)
		host._attack()
	elif is_moving == false:
			process_player_movement_input()
	elif input_direction != Vector2.ZERO:
		change_state(States.WALK)
		move(delta)
	else:
		change_state(States.IDLE)
		is_moving = false

func process_player_movement_input():
	if exit_host&&!text_controller.text_up:
		exit.play()
		$Sprite2D.show()
		if host.state != Host.States.DEAD:
			change_state(States.IDLE)
			host.state = Host.States.SEARCH

		ray.set_collision_mask_value(1, false)

		input_direction = host.anim_tree.get("parameters/Idle/blend_position").round()
		
		health_changed.emit(health, 0)
		host.player = null
		host = null
		host_active = false
		exit_host = false

		var directions = [input_direction, Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		for dir in directions:
			ray.target_position = dir * TILE_SIZE
			ray.force_raycast_update()
			if !ray.is_colliding():
				input_direction = dir
				break

	elif (!host||host.state != "Dead")&&!text_controller.text_up:
		if input_direction.y == 0:
			input_direction.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
		if input_direction.x == 0:
			input_direction.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))

	else:
		input_direction = Vector2.ZERO

	if input_direction != Vector2.ZERO:
		input_direction.normalized()
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)

		if host:
			host.anim_tree.set("parameters/Idle/blend_position", input_direction)
			host.anim_tree.set("parameters/Walk/blend_position", input_direction)
			host.anim_tree.set("parameters/Attack/blend_position", input_direction)

		ray.target_position = input_direction * TILE_SIZE
		ray.force_raycast_update()
		if !Input.is_action_pressed("tetriary")&&!ray.is_colliding():
			initial_position = position
			is_moving = true
	else:
		change_state(States.IDLE)

func move(delta):
	var movement_factor = 1.0
	if host:
		movement_factor = host.movement_factor

	percent_moved_to_next_tile += walk_speed * movement_factor * delta
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		if host&&!host_active:
			host_active = true
			$Sprite2D.hide()
	else:
		position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)

	player_move.emit(position, input_direction)
	if host&&host_active:
		host.position = position

func change_state(state: String):
	current_state = state
	if host:
		if host.state == Host.States.DEAD:
			host.anim_state.travel(Host.States.DEAD)
		else:
			host.anim_state.travel(state)
	else:
		anim_state.travel(state)

func _on_body_entered(body: Host):
	if host == null:
		host = body
		host.player = self
		host.attack = false
		ray.set_collision_mask_value(1, true)
		health_timer.start()

		if host.state == Host.States.DEAD:
			health_changed.emit(health, host.health, 10)
		else:
			host.state = Host.States.CONTROLLED
			health_changed.emit(health, host.health)

func _on_health_timer_timeout():
	if text_controller.text_up:
		return

	var host_max_health = 100

	if host&&health < max_health:
		host.health -= 2
		health += 10
		if host.state == Host.States.DEAD:
			host_max_health = 10

		if health > max_health:
			health = max_health
			health_timer.stop()
		if host.health <= 0:
			if host.state == Host.States.DEAD:
				die.play()
				host.queue_free()
				host = null
				host_active = false
				ray.set_collision_mask_value(1, false)
				$Sprite2D.show()

				health_changed.emit(health, 0)
				return
			else:
				host.health = 10
				host_max_health = 10
				health_timer.stop()
				host.state = Host.States.DEAD
				host.anim_state.travel("Dead")

		health_changed.emit(health, host.health, host_max_health)
	elif !host:
		health -= 10
		health_changed.emit(health, 0)

		if health <= 0:
			health_timer.stop()
			player_died.emit()
			get_tree().call_group("Main", "player_died")
