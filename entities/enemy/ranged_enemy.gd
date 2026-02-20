extends CharacterBody2D
class_name RangedEnemy

const ENEMY_ARROW = preload("uid://dv5i2bgbracx1")

@export var max_health: float = 1
@export var movement_speed: float = 50
@export var attack_knockback: float = 20
@export var player_detection_range: float = 50
@export var is_on_platform: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var attack_range: Area2D = $AttackRange
@onready var fleeing_range: Area2D = $FleeingRange

var player: TD2Player
var _current_health: float
var _aggresive: bool = false
var _falling: bool = false
var _stunned: bool = false

func _ready() -> void:
	_current_health = max_health
	ray_cast_2d.target_position.x = player_detection_range
	
	if is_on_platform:
		navigation_agent_2d.navigation_layers = 2
	else:
		navigation_agent_2d.navigation_layers = 1

func _physics_process(delta: float) -> void:
	look_at(player.position)
	
	if animated_sprite_2d.animation == "shooting": return
	
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play("moving")
	else:
		animated_sprite_2d.play("idle")
	
	if _falling: return
	if _stunned: 
		move_and_slide()
		return
	
	if ray_cast_2d.is_colliding(): 
		_aggresive = true
		ray_cast_2d.process_mode = Node.PROCESS_MODE_DISABLED
	
	if _aggresive:
		if attack_range.has_overlapping_bodies() and not fleeing_range.has_overlapping_bodies():
			_shoot()
		else:
			velocity = position.direction_to(navigation_agent_2d.get_next_path_position()) * movement_speed
	
	move_and_collide(velocity * delta)

func _shoot():
	animated_sprite_2d.play("shooting")
	await get_tree().create_timer(0.6).timeout
	
	var arrow: Projectile2D = ENEMY_ARROW.instantiate()
	arrow.position = position
	arrow.direction = Vector2.from_angle(rotation)
	arrow.speed = 200
	get_parent().add_child(arrow)
	
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("idle")

func _on_hurtbox_2d_take_damage(source: HitBox2D) -> void:
	_current_health -= source.damage
	if _current_health <= 0:
		queue_free()
	
	var stun_duration = source.mini_stun_duration
	
	velocity = source.global_position.direction_to(global_position) * source.knockback
	_stunned = true
	await get_tree().create_timer(0.1).timeout
	velocity = Vector2.ZERO
	await get_tree().create_timer(stun_duration).timeout
	_stunned = false

func _on_pit_detector_body_entered(_body: Node2D) -> void:
	_falling = true
	velocity = Vector2.ZERO
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_target_update_heartbeat_timeout() -> void:
	if fleeing_range.has_overlapping_bodies():
		navigation_agent_2d.target_position = position + player.position.direction_to(position) * 32
	else:
		navigation_agent_2d.target_position = player.position
