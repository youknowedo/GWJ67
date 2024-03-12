extends Control
class_name HealthUI

@export var host_health_bar: TextureProgressBar
@export var parasite_health_bar: TextureProgressBar
@export var text: Text

func _on_player_health_changed(parasite_health: int, host_health: float, host_max_health=100):
	parasite_health_bar.value = parasite_health
	host_health_bar.value = host_health
	host_health_bar.max_value = host_max_health

	if host_health == 0:
		text.change_text("No Host")
	else:
		text.change_text(str(host_health))
