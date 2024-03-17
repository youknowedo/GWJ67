extends Host
class_name Roller

var roll = false
var initial_position: Vector2
var percent_moved_to_next_tile = 0.0
var is_moving = false

func process(delta):
	if roll:
		anim_state.travel("Walk")
		percent_moved_to_next_tile += 10 * movement_factor * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (anim_tree.get("parameters/Idle/blend_position").round() * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			roll = false
			_attack()
		else:
			position = initial_position + (anim_tree.get("parameters/Idle/blend_position").round() * TILE_SIZE * percent_moved_to_next_tile)
		
		if player:
			player.position = position

func _attack():
	print("Roller attack")
	ray.target_position = anim_tree.get("parameters/Idle/blend_position") * TILE_SIZE
	ray.force_raycast_update()
	if ray.is_colliding():
		roll = false
		attack = false
		state = States.SEARCH
		position = initial_position + anim_tree.get("parameters/Idle/blend_position").round() * TILE_SIZE
		anim_state.travel("Idle")
	else:
		initial_position = position
		roll = true

	print(ray.get_collider())

func host_in_range(host: Host):
	attack = true

func host_left_range(host: Host):
	attack = false