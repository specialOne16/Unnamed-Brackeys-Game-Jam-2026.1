extends CharacterBody2D
class_name TD2Player

@export var max_health: float = 100
@export var health_pack_heal_amount: float = 50
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
@onready var movement: TD2Movement = $Components/Movement

var holding_attack: Node = null
var holding_duration = 0.0
var invincibility = 0.0

func _ready() -> void:
	if GameState.player_health == INF:
		GameState.player_health = max_health

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _process(delta: float) -> void:
	invincibility -= delta
	
	if GameState.player_health < max_health and GameState.healing_pack > 0:
		if Input.is_action_just_pressed("heal"):
			GameState.healing_pack -= 1
			GameState.player_health = clampf(GameState.player_health + health_pack_heal_amount, 0, max_health)

func take_damage(source: HitBox2D):
	if invincibility < 0:
		invincibility = invincibility_duration
		GameState.player_health -= source.damage
		
		movement.knockback(source.global_position, source.damage, source.mini_stun_duration)
