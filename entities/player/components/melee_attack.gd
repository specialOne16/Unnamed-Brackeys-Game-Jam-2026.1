extends Node
class_name MeleeAttack

@onready var player: TD2Player = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animation_manager: TD2AnimationManager = $"../AnimationManager"
@onready var hitbox: HitBox2D = $"../../Hitbox"
@onready var light_occluder_2d: LightOccluder2D = $"../../Lights/SpotLight/LightOccluder2D"

var attacking = false

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	if player.holding_attack:
		light_occluder_2d.scale.y = clampf(light_occluder_2d.scale.y - delta, 0.2, 1)
	else:
		light_occluder_2d.scale.y = 1
	
	if not attacking and Input.is_action_just_pressed("melee"):
		attacking = true
		player.holding_attack = true
		animation_manager.override_animation(self)
		animated_sprite_2d.play("attack_hold")
	
	if attacking and Input.is_action_just_released("melee"):
		player.holding_attack = false
		animated_sprite_2d.play("attack_release")
		hitbox.hit()

func _on_animation_finished():
	if animated_sprite_2d.animation == "attack_release":
		attacking = false
		animation_manager.release_override(self)
