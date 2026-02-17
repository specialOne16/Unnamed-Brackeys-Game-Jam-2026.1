extends CharacterBody2D
class_name TD2Player

@export var movement_speed: float = 250

func _physics_process(_delta: float) -> void:
	move_and_slide()
