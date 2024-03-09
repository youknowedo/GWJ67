extends Control
class_name HealthUI

@export var host_health_bar: TextureProgressBar
@export var parasite_health_bar: TextureProgressBar

@export var host_100_control: Control
@export var host_100_digit: Sprite2D
@export var host_10_control: Control
@export var host_10_digit: Sprite2D
@export var host_1_digit: Sprite2D

func _on_player_health_changed(parasite_health: int, host_health: int):
	parasite_health_bar.value = parasite_health
	host_health_bar.value = host_health

	var health_100_digit = (host_health / 100) % 10
	if health_100_digit == 0:
		host_100_control.hide()
	else:
		host_100_control.show()
		host_100_digit.frame_coords = Vector2(health_100_digit, 0)

	var health_10_digit = (host_health / 10) % 10
	if health_10_digit == 0&&health_100_digit == 0:
		host_10_control.hide()
	else:
		host_10_control.show()
		host_10_digit.frame_coords = Vector2(health_10_digit, 0)

	var health_1_digit = host_health % 10
	if health_1_digit == 0&&health_10_digit == 0&&health_100_digit == 0:
		host_1_digit.hide()
	else:
		host_1_digit.show()
		host_1_digit.frame_coords = Vector2(health_1_digit, 0)