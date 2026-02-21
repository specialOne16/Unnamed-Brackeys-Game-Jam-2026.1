extends Node
class_name EnemyMeleeAttack

@onready var enemy: Enemy = $".."
@onready var hit_box_2d: HitBox2D = $"../HitBox2D"

func _ready() -> void:
	hit_box_2d.area_entered.connect(_on_target_in_range)

func _on_target_in_range(area: Area2D):
	if area is Hurtbox2D:
		area.take_damage(hit_box_2d)
