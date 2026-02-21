extends CanvasLayer
class_name InGameUi

@onready var player_health: ProgressBar = %PlayerHealth

@onready var transition_overlay: ColorRect = $TransitionOverlay
@onready var transition_animation_player: AnimationPlayer = $TransitionAnimationPlayer

func set_player_health(current: float, max: float):
	player_health.max_value = max
	player_health.value = current

func scene_transition_in():
	get_tree().paused = true
	
	transition_overlay.visible = true
	transition_animation_player.play("fade_in")
	await transition_animation_player.animation_finished
	transition_overlay.visible = false
	
	get_tree().paused = false

func scene_transition_out():
	get_tree().paused = true
	
	transition_overlay.visible = true
	transition_animation_player.play("fade_out")
	await transition_animation_player.animation_finished
	
	get_tree().paused = false
