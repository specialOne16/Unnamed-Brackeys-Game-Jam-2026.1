extends Node
class_name Shooting

const BULLET = preload("uid://cqn62kbomqpyp")

@onready var player: TD2Player = $"../.."

func _process(_delta: float) -> void:
	if player.holding_attack == null:
		if Input.is_action_just_pressed("ranged"):
			player.holding_attack = self
			player.holding_duration = 0
	
	if player.holding_attack == self:
		if Input.is_action_just_released("ranged"):
			player.holding_attack = null
			
			if player.holding_duration >= player.charge_duration:
				_shoot_projectile()

func _shoot_projectile():
	var bullet: Projectile2D = BULLET.instantiate()
	bullet.position = player.position
	bullet.direction = Vector2.from_angle(player.rotation)
	bullet.speed = 200
	player.get_parent().add_child(bullet)
