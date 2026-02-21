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
@export var invincibility_duration: float = 3

@onready var hurtbox_2d: Hurtbox2D = $Hurtbox2D

var holding_attack: Node = null
var holding_duration = 0.0
var invincibility = 0.0

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _process(delta: float) -> void:
	invincibility -= delta
	if invincibility < 0:
		hurtbox_2d.process_mode = Node.PROCESS_MODE_INHERIT

func take_damage(source: HitBox2D):
	invincibility = invincibility_duration
	hurtbox_2d.process_mode = Node.PROCESS_MODE_DISABLED
	
	position += source.global_position.direction_to(global_position) * source.knockback
