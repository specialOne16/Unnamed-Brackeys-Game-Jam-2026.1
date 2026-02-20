extends Area2D
class_name HitBox2D

@export var damage: float
@export var knockback: float

func hit():
	for target in get_overlapping_areas():
		if target is Hurtbox2D:
			target.hurt(self)
