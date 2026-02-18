extends Node
class_name Shooting

const BULLET = preload("uid://cqn62kbomqpyp")

@onready var player: TD2Player = $"../.."

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ranged"):
		var bullet: Projectile2D = BULLET.instantiate()
		bullet.position = player.position
		bullet.direction = Vector2.from_angle(player.rotation)
		bullet.speed = 200
		player.get_parent().add_child(bullet)
