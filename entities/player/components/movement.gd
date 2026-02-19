extends Node
class_name TD2Movement

@onready var player: TD2Player = $"../.."
@onready var pit_detector: Area2D = %PitDetector
@onready var jump_timer: Timer = %JumpTimer

var air_duration = 0
var jump_position = Vector2.INF

func _ready() -> void:
	pit_detector.body_entered.connect(_pit_touched)
	jump_timer.timeout.connect(_on_land)

func _process(_delta: float) -> void:
	if jump_timer.time_left > 0: return
	
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
		
		jump_position = player.position
		jump_timer.start(player.jump_duration)
 
func _pit_touched(_body: Node2D):
	if jump_position == Vector2.INF:
		player.move_and_collide(player.velocity.normalized() * -16)
	else:
		player.position = jump_position

func _on_land():
	pit_detector.process_mode = Node.PROCESS_MODE_INHERIT
	player.set_collision_mask_value(7, true)
	
	await get_tree().physics_frame
	jump_position = Vector2.INF
