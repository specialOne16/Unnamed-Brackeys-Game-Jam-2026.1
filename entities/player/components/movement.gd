extends Node
class_name TD2Movement

@onready var player: TD2Player = $"../.."

func _process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if player.holding_attack:
		player.velocity = direction * player.charge_movement_speed
	else:
		player.velocity = direction * player.movement_speed
		if direction != Vector2.ZERO:
			player.rotation = direction.angle()
 
