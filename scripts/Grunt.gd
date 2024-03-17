extends Host
class_name Grunt

@export var attack_timer: Timer

func _attack():
	ray.target_position = anim_tree.get("parameters/Idle/blend_position") * 32 * see_distance
	ray.force_raycast_update()
	if ray.is_colliding():
		var other = ray.get_collider()

		if other is Host&&other.state != States.DEAD:
			other.take_damage(10, self)

func host_in_range(host: Host):
	attack = true

func host_left_range(host: Host):
	attack = false

func _on_attack_timer_timeout():
	if attack&&state != States.DEAD:
		state = "Attack"
