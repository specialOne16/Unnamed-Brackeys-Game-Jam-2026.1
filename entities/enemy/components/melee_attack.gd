extends Node
class_name EnemyMeleeAttack

@export var self_knockback: float = 50
@export var self_mini_stun_duration: float = 0.2

@onready var enemy: Enemy = $".."
@onready var hit_box_2d: HitBox2D = $"../HitBox2D"
@onready var hurtbox_2d: Hurtbox2D = $"../Hurtbox2D"
@onready var enemy_health: EnemyHealth = $"../EnemyHealth"

func _ready() -> void:
	hit_box_2d.area_entered.connect(_on_target_in_range)

func _on_target_in_range(area: Area2D):
	if area is Hurtbox2D:
		area.hurt(hit_box_2d)
		enemy_health.knockback(area.global_position, self_knockback, self_mini_stun_duration)
