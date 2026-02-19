extends Node
class_name TD2Movement

@onready var player: TD2Player = $"../.."
@onready var pit_detector: Area2D = %PitDetector
@onready var jumpable_detector: Area2D = %JumpableDetector
@onready var jump_timer: Timer = %JumpTimer

var jump_position = Vector2.INF
var on_jumpable = false

func _ready() -> void:
	pit_detector.body_entered.connect(_pit_touched)
	jumpable_detector.body_entered.connect(_jumpable_entered)
	jumpable_detector.body_exited.connect(_jumpable_exited)
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
		
		player.velocity = player.velocity.normalized() * player.jump_movement_speed
 
func _pit_touched(_body: Node2D):
	if jump_position == Vector2.INF:
		player.move_and_collide(player.velocity.normalized() * -16)
	else:
		player.position = jump_position

func _jumpable_entered(_body: Node2D):
	if jump_timer.time_left > 0:
		on_jumpable = true

func _jumpable_exited(_body: Node2D):
	on_jumpable = false
	if jump_timer.time_left <= 0:
		player.set_collision_mask_value(7, true)

func _on_land():
	pit_detector.process_mode = Node.PROCESS_MODE_INHERIT
	if not on_jumpable:
		player.set_collision_mask_value(7, true)
	
	await get_tree().physics_frame
	jump_position = Vector2.INF
