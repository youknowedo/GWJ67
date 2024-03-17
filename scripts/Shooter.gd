extends Host
class_name Shooter

@export var attack_timer: Timer
@export var shot: PackedScene

func _attack():
	var new_shot = shot.instantiate()
	new_shot.position = position
	new_shot.dir = anim_tree.get("parameters/Idle/blend_position").round()
	new_shot.shooter = self

	get_tree().get_root().get_node("GameControl").add_child(new_shot)

func host_in_range():
	attack = true

func host_left_range():
	attack = false

func _on_attack_timer_timeout():
	if attack&&state != States.DEAD:
		state = "Attack"
