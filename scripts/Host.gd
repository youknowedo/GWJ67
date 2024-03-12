extends CharacterBody2D
class_name Host

const TILE_SIZE = 16

@export var anim_tree: AnimationTree
@export var max_health = 100
@export var start_health = 100
@export var movement_factor = 1.0
@export var attack_damage = 25
@onready var anim_state = anim_tree.get("parameters/playback")

@onready var health = start_health
@export var dead = false

func _ready():
	position = position.snapped(Vector2.ONE * TILE_SIZE)
	position += Vector2.ONE * TILE_SIZE / 2

	if dead:
		anim_state.travel("Dead")

func _attack(_ray: RayCast2D):
	pass
