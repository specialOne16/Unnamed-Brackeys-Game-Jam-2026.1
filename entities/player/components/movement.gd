extends Node
class_name TD2Movement

@onready var player: TD2Player = $"../.."
@onready var pit_detector: Area2D = %PitDetector
@onready var platform_detector: Area2D = %PlatformDetector
@onready var near_pit_detector: Area2D = %NearPitDetector
@onready var jump_timer: Timer = %JumpTimer

var near_pit_position: Vector2
var falling_in_pit: bool = false

func _ready() -> void:
	pit_detector.body_entered.connect(_pit_touched)
	platform_detector.body_entered.connect(_platform_entered)
	platform_detector.body_exited.connect(_platform_exited)
	near_pit_detector.body_entered.connect(_near_pit_entered)
	jump_timer.timeout.connect(_on_land)
	
	if player.on_platform:
		player.set_collision_mask_value(7, false)

func _process(_delta: float) -> void:
	if jump_timer.time_left > 0: return
	
	if falling_in_pit: 
		player.velocity = Vector2.ZERO
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if player.holding_attack:
		player.velocity = direction * player.charge_movement_speed
	else:
		player.velocity = direction * player.movement_speed
		if direction != Vector2.ZERO:
			player.rotation = direction.angle()
	
	if Input.is_action_just_pressed("jump"):
		pit_detector.process_mode = Node.PROCESS_MODE_DISABLED
		player.set_collision_mask_value(7, false)
		
		jump_timer.start(player.jump_duration)
		
		player.velocity = player.velocity.normalized() * player.jump_movement_speed
 
func _pit_touched(_body: Node2D):
	falling_in_pit = true
	
	await get_tree().create_timer(1).timeout
	player.position = near_pit_position
	
	falling_in_pit = false

func _near_pit_entered(_body: Node2D):
	near_pit_position = (player.position / 16).floor() * 16 + Vector2.ONE * 8

func _platform_entered(_body: Node2D):
	if jump_timer.time_left > 0:
		player.on_platform = true

func _platform_exited(_body: Node2D):
	player.on_platform = false
	if jump_timer.time_left <= 0:
		player.set_collision_mask_value(7, true)

func _on_land():
	pit_detector.process_mode = Node.PROCESS_MODE_INHERIT
	if not player.on_platform:
		player.set_collision_mask_value(7, true)
