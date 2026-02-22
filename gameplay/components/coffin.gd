extends StaticBody2D
class_name Coffin

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal coffin_entered

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is TD2Player:
		AudioPlayer.ending_iron_maden.play()
		animated_sprite_2d.play("close")
		
		disable_player.call_deferred(body)
		coffin_entered.emit()

func disable_player(player: TD2Player):
	player.rotation = PI / 2
	player.process_mode = Node.PROCESS_MODE_DISABLED
	player.position = position
	player.animated_sprite_2d.play("idle")
