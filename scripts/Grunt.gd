extends Host

func _attack():
	ray.target_position = anim_tree.get("parameters/Idle/blend_position") * TILE_SIZE
	ray.force_raycast_update()
	if ray.is_colliding():
		var other = ray.get_collider()

		if other is Host:
			other.take_damage(10, self)