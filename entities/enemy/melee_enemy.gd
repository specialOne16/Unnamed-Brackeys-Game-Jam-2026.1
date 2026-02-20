extends CharacterBody2D
class_name MeleeEnemy

@export var max_health: float = 1
@export var movement_speed: float = 50
@export var attack_knockback: float = 20
@export var player_detection_range: float = 50
@export var knockback_stun_duration: float = 0.4
@export var is_on_platform: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

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
	if _falling: return
	if _stunned: 
		move_and_slide()
		return
	
	look_at(player.position)
	
	if ray_cast_2d.is_colliding(): 
		_aggresive = true
		ray_cast_2d.process_mode = Node.PROCESS_MODE_DISABLED
	
	if _aggresive:
		velocity = position.direction_to(navigation_agent_2d.get_next_path_position()) * movement_speed
	
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play("moving")
	else:
		animated_sprite_2d.play("idle")
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is TD2Player:
			collider.bump(position, attack_knockback)


func _on_hurtbox_2d_take_damage(source: HitBox2D) -> void:
	_current_health -= source.damage
	if _current_health <= 0:
		queue_free()
	
	velocity = source.global_position.direction_to(global_position) * source.knockback
	_stunned = true
	await get_tree().create_timer(0.1).timeout
	velocity = Vector2.ZERO
	await get_tree().create_timer(knockback_stun_duration).timeout
	_stunned = false

func _on_pit_detector_body_entered(_body: Node2D) -> void:
	_falling = true
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_target_update_heartbeat_timeout() -> void:
	navigation_agent_2d.target_position = player.position
