extends CharacterBody2D
class_name TD2Player

@export var movement_speed: float = 100
var holding_attack = false

func _physics_process(_delta: float) -> void:
	move_and_slide()
