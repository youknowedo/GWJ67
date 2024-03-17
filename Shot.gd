extends Area2D

var shooter: Shooter
var dir: Vector2

func _process(delta):
	if dir:
		position += dir * delta * 128

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body: Node2D):
	if body != shooter:
		if body is Grunt:
			body.take_damage(100, shooter)
		if body is Roller:
			body.take_damage(10, shooter)
		if body is Shooter:
			body.take_damage(30, shooter)

		queue_free()
