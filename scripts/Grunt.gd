extends Host
class_name Grunt

@export var attack_timer: Timer

func _ready():
	attack_timer.connect("timeout", _attack)

func _attack():
	ray.target_position = anim_tree.get("parameters/Idle/blend_position") * TILE_SIZE
	ray.force_raycast_update()
	if ray.is_colliding():
		var other = ray.get_collider()

		if other is Host:
			other.take_damage(10)

func host_in_range(host: Host):
	attack_timer.start()

func host_out_of_range(host: Host):
	attack_timer.stop()
