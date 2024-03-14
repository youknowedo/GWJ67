extends CharacterBody2D
class_name Host

const TILE_SIZE = 16
const States = {
	SEARCH = "Search",
	DEAD = "Dead",
	CONTROLLED = "Controlled",
	CHASE = "Chase",
	ATTACK = "Attack",
}

@export var ray: RayCast2D
@export var tile_map: TileMap
@export var anim_tree: AnimationTree
@export var reveal_position_timer: Timer
@export var max_health = 100
@export var start_health = 100
@export var movement_factor = 1.0
@export var attack_damage = 25
@export var spawn_direction = Vector2.RIGHT
@export_enum("Search", "Dead", "Controlled", "Walk") var state = States.SEARCH

@onready var anim_state = anim_tree.get("parameters/playback")
@onready var health = start_health
@onready var astar = AStarGrid2D.new()

var target: Host
var last_seen_target_position: Vector2

var player_speed = 6.0
var revealed_position: Vector2
var percent_moved_to_next_tile = 0.0
var initial_position: Vector2
var is_moving = false
var move_direction: Vector2

func _ready():
	reveal_position_timer.connect("timeout", _on_reveal_position_timeout)

	anim_tree.set("parameters/Idle/blend_position", spawn_direction)
	anim_tree.set("parameters/Walk/blend_position", spawn_direction)
	anim_tree.set("parameters/Attack/blend_position", spawn_direction)

	if state == States.DEAD:
		anim_state.travel("Dead")
		return

	astar.region = tile_map.get_used_rect()
	astar.cell_size = Vector2(TILE_SIZE, TILE_SIZE)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()

func _physics_process(delta):
	if state == States.DEAD||state == States.CONTROLLED:
		return

	if state == States.CHASE:
		if !is_moving:
			initial_position = global_position
			var attacker_direction = (target.revealed_position - global_position).normalized()
			ray.target_position = attacker_direction * 160
			ray.set_collision_mask_value(1, false)
			ray.force_raycast_update()

			var collider = ray.get_collider()
			print(collider, attacker_direction)
			if collider&&collider == target:
				last_seen_target_position = target.revealed_position

			var id_path = astar.get_id_path(
				tile_map.local_to_map(global_position),
				tile_map.local_to_map(last_seen_target_position)
			)
			print(self)
			print(id_path,
				tile_map.local_to_map(global_position),
				tile_map.local_to_map(last_seen_target_position)
			)

			if id_path.size() <= 1:
				state = States.SEARCH
				return

			move_direction = id_path[1] - id_path[0]

			print(move_direction)
			ray.target_position = move_direction * TILE_SIZE
			ray.set_collision_mask_value(1, true)
			ray.force_raycast_update()
			if ray.is_colliding():
				print("Colliding", ray.get_collider())
				state = States.SEARCH
				return

			is_moving = true

		print(percent_moved_to_next_tile)
		percent_moved_to_next_tile += player_speed * movement_factor * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (move_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			print("Reached tile")
		else:
			position = initial_position + (move_direction * TILE_SIZE * percent_moved_to_next_tile)

func take_damage(damage: int, by: Host):
	health -= damage
	if health <= 0:
		health = 10
		state = States.DEAD
		anim_state.travel("Dead")

	by.revealed_position = by.global_position
	get_tree().call_group("Host", "ally_attacked", by, self)

func ally_attacked(by: Host, from: Host):
	if state != States.SEARCH||from == target:
		return

	var attacker_direction = (by.global_position - global_position).normalized()
	ray.target_position = attacker_direction * 160
	ray.force_raycast_update()

	var collider = ray.get_collider()
	if collider&&collider == by:
		target = by
		state = States.CHASE

func _on_reveal_position_timeout():
	revealed_position = global_position

func _attack():
	pass
