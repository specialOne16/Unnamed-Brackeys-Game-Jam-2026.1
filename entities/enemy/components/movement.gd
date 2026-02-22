extends Node
class_name EnemyMovement

@onready var enemy: Enemy = $".."
@onready var ray_cast_2d: RayCast2D = $"../RayCast2D"
@onready var navigation_agent_2d: NavigationAgent2D = $"../NavigationAgent2D"
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var target_update_heartbeat: Timer = $"../TargetUpdateHeartbeat"
@onready var attack_range: Area2D = $"../AttackRange"
@onready var fleeing_range: Area2D = $"../FleeingRange"

func _ready() -> void:
	target_update_heartbeat.timeout.connect(_update_target)
	if fleeing_range:
		fleeing_range.body_entered.connect(_start_fleeing)
		fleeing_range.body_exited.connect(_stop_fleeing)
	
	ray_cast_2d.target_position.x = enemy.player_detection_range

func _physics_process(_delta: float) -> void:
	if enemy.movement_override != null: return
	
	if enemy.velocity != Vector2.ZERO:
		animated_sprite_2d.play("moving")
	else:
		animated_sprite_2d.play("idle")
	
	if ray_cast_2d.get_collider() == enemy.player: 
		if not enemy.aggresive:
			AudioPlayer.enemy_aggro.play()
		enemy.aggresive = true
		ray_cast_2d.process_mode = Node.PROCESS_MODE_DISABLED
	
	if _should_run():
		enemy.velocity = enemy.position.direction_to(navigation_agent_2d.get_next_path_position()) * enemy.movement_speed
		enemy.rotation = enemy.velocity.angle()
	else:
		enemy.velocity = Vector2.ZERO
		enemy.look_at(enemy.player.position)
	
	enemy.move_and_slide()

func _update_target():
	if enemy.fleeing:
		navigation_agent_2d.target_position = enemy.position + enemy.player.position.direction_to(enemy.position) * 16
	else:
		navigation_agent_2d.target_position = enemy.player.position

func _start_fleeing(body: Node2D):
	if body is TD2Player:
		enemy.fleeing = true
		_update_target()

func _stop_fleeing(body: Node2D):
	if body is TD2Player:
		enemy.fleeing = false

func _should_run() -> bool:
	if enemy.fleeing: return true
	if enemy.aggresive:
		if attack_range == null:
			return true
		else:
			return not attack_range.overlaps_body(enemy.player)
	
	return false
