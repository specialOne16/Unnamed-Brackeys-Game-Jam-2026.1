extends Node
class_name TD2AnimationManager

const DIR = ["right", "down", "left", "up"]

var face_direction: String = "down"
var animation_override: Node = null

@onready var player: TD2Player = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

func _process(_delta: float) -> void:
	if animation_override != null: return
	
	if player.velocity != Vector2.ZERO:
		animated_sprite_2d.play("move")
	else:
		animated_sprite_2d.play("idle")

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
