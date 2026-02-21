extends CanvasLayer
class_name InGameUi

@onready var player_health: ProgressBar = %PlayerHealth
@onready var main_inventory: Label = $MarginContainer/Control/MainInventory

@onready var transition_overlay: ColorRect = $TransitionOverlay
@onready var transition_animation_player: AnimationPlayer = $TransitionAnimationPlayer

func set_player_health(max_hp: float):
	player_health.max_value = max_hp

func _ready() -> void:
	update_inventory()

func _process(_delta: float) -> void:
	update_inventory()

func update_inventory():
	main_inventory.text = "Shotgun: %d\nHealth Pack: %d" % [GameState.shotgun, GameState.healing_pack]
	player_health.value = GameState.player_health

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
