extends Area2D
class_name Hurtbox2D

signal take_damage(source: HitBox2D)

func hurt(source: HitBox2D):
	take_damage.emit(source)
