extends Node
class_name TD2Movement

@onready var player: TD2Player = $"../.."
@onready var lights: Node2D = %Lights

func _process(_delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * player.movement_speed
	
	var mouse = get_viewport().get_mouse_position()
	lights.look_at(mouse)
