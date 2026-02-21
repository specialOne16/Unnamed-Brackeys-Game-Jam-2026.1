extends Node
class_name EnemyRangedAttack

const ENEMY_ARROW = preload("uid://dv5i2bgbracx1")

@export var attack_cooldown: float = 3

@onready var enemy: Enemy = $".."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var arrow_spawn: Node2D = $"../ArrowSpawn"
@onready var attack_range: Area2D = $"../AttackRange"
@onready var attack_animation_timer: Timer = $"../AttackAnimationTimer"
@onready var fleeing_range: Area2D = $"../FleeingRange"

var _remaining_attack_cooldown = 0

func _ready() -> void:
	attack_animation_timer.timeout.connect(_shoot)
	animated_sprite_2d.animation_finished.connect(_shooting_complete)
	fleeing_range.body_entered.connect(_start_fleeing)

func _process(delta: float) -> void:
	if enemy.fleeing: return
	
	if enemy.aggresive:
		_remaining_attack_cooldown -= delta
		
		if _remaining_attack_cooldown <= 0:
			if attack_range.has_overlapping_bodies():
				if enemy.override_movement(self):
					enemy.look_at(enemy.player.position)
					if enemy.animated_sprite_2d.animation != "shooting":
						enemy.animated_sprite_2d.play("shooting")
						attack_animation_timer.start()

func _shoot():
	if enemy.movement_override != self: return
	_remaining_attack_cooldown = attack_cooldown
	
	var arrow: Projectile2D = ENEMY_ARROW.instantiate()
	arrow.position = arrow_spawn.global_position
	arrow.direction = Vector2.from_angle(enemy.rotation)
	enemy.get_parent().add_child(arrow)

func _start_fleeing(body: Node2D):
	if body is TD2Player:
		attack_animation_timer.stop()
		enemy.unoverride_movement(self)

func _shooting_complete():
	if animated_sprite_2d.animation == "shooting":
		enemy.unoverride_movement(self)
