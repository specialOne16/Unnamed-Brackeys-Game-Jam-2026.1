extends Node
class_name Shooting

@onready var player: TD2Player = $"../.."
@onready var shotgun: AnimatedSprite2D = $"../../Shotgun"
@onready var ranged_hitbox: HitBox2D = $"../../RangedHitbox"
@onready var light_occluder_2d: LightOccluder2D = $"../../Lights/SpotLight/LightOccluder2D"

var attacking = false

func _ready() -> void:
	shotgun.animation_finished.connect(_on_animation_finished)
	
	shotgun.visible = false

func _process(_delta: float) -> void:
	if player.holding_attack == null:
		if  not attacking and Input.is_action_just_pressed("ranged"):
			player.holding_attack = self
			player.holding_duration = 0
			attacking = true
	
	if player.holding_attack == self:
		if attacking and Input.is_action_just_released("ranged"):
			if player.holding_duration >= player.charge_duration:
				shotgun.visible = true
				shotgun.play("attack")
				ranged_hitbox.hit()
			else:
				_release_attack()

func _on_animation_finished():
	if shotgun.animation == "attack":
		_release_attack()

func _release_attack():
	attacking = false
	player.holding_attack = null
	shotgun.visible = false
