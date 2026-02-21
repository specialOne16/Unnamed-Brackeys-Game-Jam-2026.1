extends Node
class_name EnemyHealth

@onready var enemy: Enemy = $".."
@onready var hurtbox_2d: Hurtbox2D = $"../Hurtbox2D"
@onready var knockback_timer: Timer = $"../KnockbackTimer"
@onready var stun_timer: Timer = $"../StunTimer"
@onready var pit_detector: Area2D = $"../PitDetector"
@onready var vertical_animation: AnimationPlayer = $"../VerticalAnimation"

var _current_health: float

func _ready() -> void:
	hurtbox_2d.take_damage.connect(_hurt)
	pit_detector.body_entered.connect(_pit_entered)
	knockback_timer.timeout.connect(_stop_knockback)
	stun_timer.timeout.connect(_stop_stun)
	vertical_animation.animation_finished.connect(_fallen)
	
	_current_health = enemy.max_health

func _physics_process(_delta: float) -> void:
	if enemy.movement_override == self:
		if vertical_animation.current_animation == "falling":
			pass
		else:
			enemy.move_and_slide()

func _hurt(source: HitBox2D):
	_current_health -= source.damage
	if _current_health <= 0:
		enemy.queue_free()
	
	knockback_timer.stop()
	stun_timer.stop()
	
	knockback(source.global_position, source.knockback, source.mini_stun_duration)

func knockback(source: Vector2, power: float, stun: float):
	enemy.movement_override = self
	
	enemy.velocity = source.direction_to(enemy.global_position) * power
	knockback_timer.start(0.1)
	stun_timer.start(stun + 0.1)

func _stop_knockback():
	enemy.velocity = Vector2.ZERO

func _stop_stun():
	enemy.movement_override = null

func _pit_entered(_body: Node2D):
	enemy.movement_override = self
	vertical_animation.play("falling")
	
	knockback_timer.stop()
	stun_timer.stop()

func _fallen(anim_name: String):
	if anim_name == "falling": enemy.queue_free()
