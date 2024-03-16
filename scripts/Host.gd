extends CharacterBody2D
class_name Host

const TILE_SIZE = 16
const States = {
	SEARCH = "Search",
	DEAD = "Dead",
	CONTROLLED = "Controlled",
	ATTACK = "Attack",
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

func _ready():
	anim_tree.set("parameters/Idle/blend_position", spawn_direction)
	anim_tree.set("parameters/Walk/blend_position", spawn_direction)
	anim_tree.set("parameters/Attack/blend_position", spawn_direction)

	if state == States.DEAD:
		anim_tree.set("parameters/Idle/blend_position", spawn_direction)
		anim_state.travel("Dead")
		return

	ready()

func ready():
	pass

func _process(delta):
	if state == States.DEAD||state == States.CONTROLLED:
		return

	ray.target_position = anim_tree.get("parameters/Idle/blend_position") * 64
	ray.force_raycast_update()

	var collider = ray.get_collider()
	print(collider)
	if collider:
		if collider is Host:
			host_in_range(collider)
	else:
		host_left_range(collider)

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		health = 10
		state = States.DEAD

func _attack():
	pass

func host_in_range(_host: Host):
	pass
	
func host_left_range(_host: Host):
	pass