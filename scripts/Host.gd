extends CharacterBody2D
class_name Host

const TILE_SIZE = 16
const States = [
	"Idle",
	"Dead",
	"Controlled",
	"Walk",
]

@export var anim_tree: AnimationTree
@export var max_health = 100
@export var start_health = 100
@export var movement_factor = 1.0
@export var attack_damage = 25
@export var spawn_direction = Vector2.RIGHT
@export_enum("Idle", "Dead", "Controlled", "Walk") var state = "Idle"

@onready var anim_state = anim_tree.get("parameters/playback")
@onready var health = start_health

func _ready():
	anim_tree.set("parameters/Idle/blend_position", spawn_direction)
	anim_tree.set("parameters/Walk/blend_position", spawn_direction)
	anim_tree.set("parameters/Attack/blend_position", spawn_direction)

	if state == "Dead":
		anim_state.travel("Dead")

func _attack(_ray: RayCast2D):
	pass
