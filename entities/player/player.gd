extends CharacterBody2D
class_name TD2Player

@export var movement_speed: float = 100
@export var charge_movement_speed: float = 40
@export var jump_movement_speed: float = 100
@export var radial_vision_scale: float = 1
@export var cone_vision_scale: float = 1
@export var charge_cone_vision_scale: float = 0.2
@export var charge_duration: float = 2
@export var jump_duration: float = 1

var holding_attack: Node = null
var holding_duration = 0.0

func _physics_process(_delta: float) -> void:
	move_and_slide()
