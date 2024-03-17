extends Host
class_name Grunt

@export var attack_timer: Timer

func _attack():
	ray.target_position = anim_tree.get("parameters/Idle/blend_position") * 16 * see_distance
	ray.force_raycast_update()
	if ray.is_colliding():
		var body = ray.get_collider()

		if body is Host&&body.state != States.DEAD:
			if body is Roller:
				body.take_damage(100, self)
			if body is Shooter:
				body.take_damage(10, self)
			if body is Grunt:
				body.take_damage(30, self)

func host_in_range():
	attack = true

func host_left_range():
	attack = false

func _on_attack_timer_timeout():
	if attack&&state != States.DEAD:
		state = "Attack"
