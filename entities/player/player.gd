extends CharacterBody2D
class_name TD2Player

signal dead

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
@export var fall_damage: float = 0
@export var invincibility_duration: float = 3

@onready var hurtbox_2d: Hurtbox2D = $Hurtbox2D
@onready var movement: TD2Movement = $Components/Movement
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var healing: AnimatedSprite2D = $Healing
@onready var lights: Node2D = %Lights

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
	
	healing.global_rotation = 0
	if GameState.player_health < max_health and GameState.has_health_pack():
		if Input.is_action_just_pressed("heal") and GameState.use_health_pack():
			healing.play("heal")
			GameState.player_health = clampf(GameState.player_health + health_pack_heal_amount, 0, max_health)

func take_damage(source: HitBox2D):
	if await take_pure_damage(source.damage):
		movement.knockback(source.global_position, source.damage, source.mini_stun_duration)

func take_pure_damage(amount: float) -> bool:
	var should_knockback = false
	
	if invincibility < 0:
		AudioPlayer.player_taking_damage.play()
		
		invincibility = invincibility_duration
		GameState.player_health -= amount
		
		if GameState.player_health <= 0:
			process_mode = Node.PROCESS_MODE_DISABLED
			animated_sprite_2d.play("died")
			await animated_sprite_2d.animation_finished
			dead.emit()
		else:
			should_knockback = true
	
	return should_knockback
	
