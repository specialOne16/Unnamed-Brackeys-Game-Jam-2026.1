extends Node
class_name TD2Movement

@onready var player: TD2Player = $"../.."
@onready var pit_detector: Area2D = %PitDetector
@onready var near_pit_detector: Area2D = %NearPitDetector
@onready var platform_detector: Area2D = %PlatformDetector
@onready var jump_timer: Timer = %JumpTimer
@onready var vertical_animation: AnimationPlayer = $"../../VerticalAnimation"

var near_pit_position: Vector2
var falling_in_pit: bool = false
var knockbacking: bool = false

func knockback(source: Vector2, power: float, stun: float):
	knockbacking = true
	
	player.velocity = source.direction_to(player.global_position) * power
	await get_tree().create_timer(0.1).timeout
	player.velocity = Vector2.ZERO
	await get_tree().create_timer(stun).timeout
	
	knockbacking = false

func _ready() -> void:
	pit_detector.body_entered.connect(_pit_touched)
	near_pit_detector.body_exited.connect(_pit_touched)
	platform_detector.body_exited.connect(_on_fall_from_platform)
	vertical_animation.animation_finished.connect(_on_vertical_animation_finished)

func _process(_delta: float) -> void:
	if jump_timer.time_left > 0: return
	
	if falling_in_pit: 
		player.velocity = Vector2.ZERO
		return
	
	if knockbacking:
		player.move_and_slide()
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if player.holding_attack:
		player.velocity = direction * player.charge_movement_speed
	else:
		player.velocity = direction * player.movement_speed
		if direction != Vector2.ZERO:
			player.rotation = direction.angle()
	
	if Input.is_action_just_pressed("jump"):
		player.set_collision_mask_value(9, false)
		
		vertical_animation.play("jumping_up", -1, 1 / player.jump_duration)
		jump_timer.start(player.jump_duration)
		
		player.velocity = player.velocity.normalized() * player.jump_movement_speed
	
	if not pit_detector.has_overlapping_bodies():
		near_pit_position = (player.position / 16).floor() * 16 + Vector2.ONE * 8
 
func _pit_touched(_body: Node2D):
	if pit_detector.has_overlapping_bodies() and not near_pit_detector.has_overlapping_bodies():
		if jump_timer.time_left > 0: return
		
		falling_in_pit = true
		
		vertical_animation.play("falling")
		await get_tree().create_timer(1).timeout
		vertical_animation.play("RESET")
		player.position = near_pit_position
		
		falling_in_pit = false

func _on_vertical_animation_finished(anim_name: String):
	match anim_name:
		"jumping_up":
			if not platform_detector.has_overlapping_bodies():
				player.set_collision_mask_value(9, true)
				vertical_animation.play("jumping_down", -1, 1 / player.jump_duration)
		
		"jumping_down": _pit_touched(null)

func _on_fall_from_platform(_body: Node2D):
	player.set_collision_mask_value(9, true)
	vertical_animation.play("jumping_down", -1, 1 / player.jump_duration)
