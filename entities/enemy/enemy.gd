extends Node2D
class_name Enemy

@onready var hurtbox_2d: Hurtbox2D = %Hurtbox2D

func _ready() -> void:
	hurtbox_2d.take_damage.connect(_take_damage)

func _take_damage(_amount: float):
	queue_free.call_deferred()
