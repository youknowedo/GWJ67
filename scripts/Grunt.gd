extends Host

func _attack(dir: Vector2, ray: RayCast2D):
	ray.target_position = dir * TILE_SIZE
	ray.force_raycast_update()
	if ray.is_colliding():
		var other = ray.get_collider()

		if other is Host:
			other.health -= attack_damage
			if other.health <= 0:
				other.health = 10
				other.dead = true
				other.anim_state.travel("Dead")