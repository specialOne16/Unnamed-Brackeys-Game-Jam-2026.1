extends Node
class_name TD2AnimationManager

const DIR = ["right", "down", "left", "up"]

var face_direction: String = "down"

@onready var player: TD2Player = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

func _process(_delta: float) -> void:
	var direction = player.velocity
	
	if direction != Vector2.ZERO:
		var last_dir = Vector2.from_angle(DIR.find(face_direction) * TAU / 4)
		var angle = (direction + 0.1 * last_dir).angle()
		face_direction = DIR[roundi((angle / TAU) * 4)]
		animated_sprite_2d.play("move_%s" % face_direction)
	else:
		animated_sprite_2d.play("idle_%s" % face_direction)
