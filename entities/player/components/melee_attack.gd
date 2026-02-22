extends Node
class_name MeleeAttack

@onready var player: TD2Player = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var animation_manager: TD2AnimationManager = $"../AnimationManager"
@onready var melee_hitbox: HitBox2D = $"../../MeleeHitbox"
@onready var light_occluder_2d: LightOccluder2D = $"../../Lights/SpotLight/LightOccluder2D"

var attacking = false

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _process(_delta: float) -> void:
	if player.holding_attack == null:
		if  not attacking and Input.is_action_pressed("melee"):
			player.holding_attack = self
			player.holding_duration = 0
			attacking = true
			
			animation_manager.override_animation(self)
			animated_sprite_2d.play("attack_hold")
	
	if player.holding_attack == self:
		if attacking and Input.is_action_just_released("melee"):
			attacking = false
			if player.holding_duration >= player.charge_duration:
				if melee_hitbox.has_overlapping_areas():
					AudioPlayer.melee_with_impact.play()
				else:
					AudioPlayer.melee_no_impact.play()
				
				animated_sprite_2d.play("attack_release")
				melee_hitbox.hit()
			else:
				_release_attack()

func _on_animation_finished():
	if animated_sprite_2d.animation == "attack_release":
		_release_attack()

func _release_attack():
	if Input.is_action_pressed("melee"): 
		player.holding_duration = 0
		animated_sprite_2d.play("attack_hold")
		attacking = true
		return
	
	player.holding_attack = null
	animation_manager.release_override(self)
