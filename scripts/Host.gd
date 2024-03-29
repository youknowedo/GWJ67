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
@export var anim_tree: AnimationTree
@export var max_health = 100
@export var start_health = 100
@export var movement_factor = 1.0
@export var attack_damage = 25
@export var spawn_direction = Vector2.RIGHT
@export var see_distance = 2
@export_enum("Search", "Dead", "Controlled", "Walk") var state = States.SEARCH

@onready var die: AudioStreamPlayer = $Die
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var health = start_health

var attack = false
var stop_looking = false
var player: Player

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
	process(delta)
	if state == States.DEAD:
		anim_state.travel("Dead")
		return

	if state == States.CONTROLLED:
		return

	if state == States.ATTACK:
		anim_state.travel("Attack")
		_attack()
		state = States.SEARCH
		await get_tree().create_timer(.2).timeout
		anim_state.travel("Idle")
		
	ray.target_position = anim_tree.get("parameters/Idle/blend_position") * 16 * see_distance
	ray.force_raycast_update()

	var collider = ray.get_collider()
	if collider:
		if collider is Host:
			if collider.state == States.DEAD:
				host_left_range()
			else:
				if !stop_looking:
					host_in_range()
	else:
		host_left_range()

func process(_delta):
	pass

func take_damage(damage: int, by: Host):
	health -= damage
	if health <= 0:
		health = 10
		max_health = 10
		state = States.DEAD
		anim_state.travel("Dead")
		die.play()

	anim_tree.set("parameters/Idle/blend_position", by.anim_tree.get("parameters/Idle/blend_position") * - 1)
	anim_tree.set("parameters/Walk/blend_position", by.anim_tree.get("parameters/Walk/blend_position") * - 1)
	anim_tree.set("parameters/Attack/blend_position", by.anim_tree.get("parameters/Attack/blend_position") * - 1)

	if state == States.CONTROLLED:
		player.health_changed.emit(player.health, health, max_health)

	damage_taken()

func _attack():
	pass

func host_in_range():
	pass
	
func host_left_range():
	pass

func damage_taken():
	pass