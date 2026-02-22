extends CanvasLayer
class_name InGameUi

@onready var player_health: TextureProgressBar = %PlayerHealth
@onready var relics_2: Sprite2D = %Relics2
@onready var relics_1: Sprite2D = %Relics1
@onready var inventory_1: Sprite2D = %Inventory1
@onready var inventory_2: Sprite2D = %Inventory2

@onready var transition_overlay: ColorRect = $TransitionOverlay
@onready var transition_animation_player: AnimationPlayer = $TransitionAnimationPlayer

func set_player_health(max_hp: float):
	player_health.max_value = max_hp

func _ready() -> void:
	update_inventory()

func _process(_delta: float) -> void:
	update_inventory()

func update_inventory():
	player_health.value = GameState.player_health
	relics_1.visible = GameState.relic_1_collected
	relics_2.visible = GameState.relic_2_collected
	
	match GameState.inventory_1:
		GroundItem.Type.HEALTH_PACK: inventory_1.frame = 4
		GroundItem.Type.SHOTGUN_AMMO: inventory_1.frame = 5
		GroundItem.Type.HALF_SHOTGUN_AMMO: inventory_1.frame = 6
		_: inventory_1.frame = 3
	
	match GameState.inventory_2:
		GroundItem.Type.HEALTH_PACK: inventory_2.frame = 4
		GroundItem.Type.SHOTGUN_AMMO: inventory_2.frame = 5
		GroundItem.Type.HALF_SHOTGUN_AMMO: inventory_2.frame = 6
		_: inventory_2.frame = 3

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
