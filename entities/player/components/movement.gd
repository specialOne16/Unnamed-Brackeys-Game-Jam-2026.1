extends Node
class_name TD2Movement

@onready var player: TD2Player = $"../.."
@onready var pit_detector: Area2D = %PitDetector
@onready var near_pit_detector: Area2D = %NearPitDetector
@onready var jump_timer: Timer = %JumpTimer
@onready var vertical_animation: AnimationPlayer = $"../../VerticalAnimation"

var near_pit_position: Vector2
var falling_in_pit: bool = false

func _ready() -> void:
	pit_detector.body_entered.connect(_pit_touched)
	near_pit_detector.body_entered.connect(_near_pit_entered)
	jump_timer.timeout.connect(_on_land)

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
		
		vertical_animation.play("jumping", -1, 1 / player.jump_duration)
		jump_timer.start(player.jump_duration)
		
		player.velocity = player.velocity.normalized() * player.jump_movement_speed
 
func _pit_touched(_body: Node2D):
	falling_in_pit = true
	
	vertical_animation.play("falling")
	await get_tree().create_timer(1).timeout
	vertical_animation.play("RESET")
	player.position = near_pit_position
	
	falling_in_pit = false

func _near_pit_entered(_body: Node2D):
	near_pit_position = (player.position / 16).floor() * 16 + Vector2.ONE * 8

func _on_land():
	pit_detector.process_mode = Node.PROCESS_MODE_INHERIT
