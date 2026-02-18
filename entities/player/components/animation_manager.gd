extends Node
class_name TD2AnimationManager

const DIR = ["right", "down", "left", "up"]

var face_direction: String = "down"
var animation_override: Node = null

@onready var player: TD2Player = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var light_occluder_2d: LightOccluder2D = $"../../Lights/SpotLight/LightOccluder2D"

func _process(delta: float) -> void:
	if animation_override == null:
		if player.velocity != Vector2.ZERO:
			animated_sprite_2d.play("move")
		else:
			animated_sprite_2d.play("idle")
	
	if player.holding_attack:
		player.holding_duration += delta
		
		var hold_percentage = clampf(player.holding_duration / player.charge_duration, 0, 1)
		light_occluder_2d.scale.y = lerpf(player.cone_vision_scale, player.charge_cone_vision_scale, hold_percentage)
	else:
		light_occluder_2d.scale.y = player.cone_vision_scale

func override_animation(override: Node) -> bool:
	if animation_override == null:
		animation_override = override
		return true
	
	if animation_override == override:
		return true
	
	return false

func release_override(override: Node):
	if animation_override == override:
		animation_override = null
