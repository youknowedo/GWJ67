extends Host
class_name Roller

var roll = false
var initial_position: Vector2
var percent_moved_to_next_tile = 0.0
var is_moving = false

func process(delta):
	if roll:
		anim_state.travel("Walk")
		percent_moved_to_next_tile += 10 * delta
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
	ray.target_position = anim_tree.get("parameters/Idle/blend_position") * TILE_SIZE
	ray.force_raycast_update()
	var body = ray.get_collider()
	if body:
		roll = false
		attack = false
		state = States.SEARCH
		position = initial_position + anim_tree.get("parameters/Idle/blend_position").round() * TILE_SIZE
		anim_state.travel("Idle")
		stop_looking = true

		print(body, "hi")
		if body is Host&&body.state != States.DEAD:
			if body is Shooter:
				body.take_damage(100, self)
			if body is Shooter:
				body.take_damage(10, self)
			if body is Grunt:
				body.take_damage(30, self)
	else:
		initial_position = position
		roll = true

func host_in_range():
	if !roll:
		_attack()

func host_left_range():
	print("Host left range")
	stop_looking = false