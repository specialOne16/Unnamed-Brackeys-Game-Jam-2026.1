extends Node
class_name TD2Movement

@onready var player: TD2Player = $"../.."

func _process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * player.movement_speed
	
	if player.holding_attack:
		player.velocity /= 3
	else:
		var mouse = get_viewport().get_mouse_position()
		player.look_at(mouse)
