extends CharacterBody2D
class_name Host

const TILE_SIZE = 16
const States = {
	SEARCH = "Search",
	DEAD = "Dead",
	CONTROLLED = "Controlled",
	WALK = "Walk",
}

@export var ray: RayCast2D
@export var tile_map: TileMap
@export var anim_tree: AnimationTree
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
var walk_path: Array[Vector2i] = []

func _ready():
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

func _physics_process(_delta):
	pass

func _attack():
	pass

func take_damage(damage: int, by: Host):
	health -= damage
	if health <= 0:
		health = 10
		state = States.DEAD
		anim_state.travel("Dead")

	get_tree().call_group("Host", "ally_attacked", by, self)

func ally_attacked(by: Host, from: Host):
	if from == target:
		return

	var attacker_direction = (by.global_position - global_position).normalized()
	ray.target_position = attacker_direction * 10
	ray.force_raycast_update()

	var collider = ray.get_collider()
	print(collider)
	if collider&&collider == by:
		var id_path = astar.get_id_path(global_position, by.global_position)

		print(id_path)
