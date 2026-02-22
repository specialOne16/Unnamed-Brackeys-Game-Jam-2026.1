extends CanvasLayer
class_name InGameUi

@onready var player_health: TextureProgressBar = %PlayerHealth
@onready var relics_2: Sprite2D = %Relics2
@onready var relics_1: Sprite2D = %Relics1

@onready var transition_overlay: ColorRect = $TransitionOverlay
@onready var transition_animation_player: AnimationPlayer = $TransitionAnimationPlayer
@onready var health_pack_label: Label = $MarginContainer/Control/Items/Control/HealthPackLabel
@onready var shotgun_ammo_label: Label = $MarginContainer/Control/Items/Control2/ShotgunAmmoLabel
@onready var pause_menu: PanelContainer = $PauseMenu
@onready var restart_checkpoint_button: TextureButton = $PauseMenu/Control/VBoxContainer/RestartCheckpointButton
@onready var reset_warning: Label = $PauseMenu/Control/ResetWarning

var game_paused = false

func set_player_health(max_hp: float):
	player_health.max_value = max_hp

func _ready() -> void:
	update_inventory()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		game_paused = true
	
	update_inventory()

func update_inventory():
	player_health.value = GameState.player_health
	relics_1.visible = GameState.relic_1_collected
	relics_2.visible = GameState.relic_2_collected
	
	health_pack_label.text = str(GameState.health_pack)
	shotgun_ammo_label.text = str(GameState.shotgun_ammo)
	
	pause_menu.visible = game_paused
	if game_paused:
		get_tree().paused = true
	
	reset_warning.visible = restart_checkpoint_button.is_hovered()

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


func _on_resume_button_pressed() -> void:
	game_paused = false
	get_tree().paused = false


func _on_restart_checkpoint_button_pressed() -> void:
	await scene_transition_out()
	GameState.respawn()


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), 
		value
	)
