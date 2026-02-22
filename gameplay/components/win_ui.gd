extends Control
class_name WinUi

@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect_2: TextureRect = $TextureRect2
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play():
	visible = true
	animation_player.play("new_animation")
	await animation_player.animation_finished
	label.visible = true
