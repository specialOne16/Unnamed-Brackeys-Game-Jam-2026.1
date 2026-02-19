extends CanvasLayer
class_name InGameUi

@onready var transition_animation_player: AnimationPlayer = $TransitionAnimationPlayer

func scene_transition_in():
	get_tree().paused = true
	
	visible = true
	transition_animation_player.play("fade_in")
	await transition_animation_player.animation_finished
	visible = false
	
	get_tree().paused = false

func scene_transition_out():
	get_tree().paused = true
	
	visible = true
	transition_animation_player.play("fade_out")
	await transition_animation_player.animation_finished
	
	get_tree().paused = false
