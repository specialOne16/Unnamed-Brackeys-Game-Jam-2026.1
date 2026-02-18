extends Area2D
class_name Hurtbox2D

signal take_damage(amount: float)

func hurt(source: HitBox2D):
	take_damage.emit(source.damage)
