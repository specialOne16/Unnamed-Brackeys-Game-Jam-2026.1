extends AnimatableBody2D
class_name Projectile2D

const LIGHT_ONLY = preload("uid://bnu2oiso3alir")

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var hitbox: HitBox2D
@export var explosion: GPUParticles2D
@export var speed: float

var direction: Vector2

func _ready() -> void:
	sprite_2d.material = LIGHT_ONLY
	rotation = direction.angle()
	#explosion.process_mode = Node.PROCESS_MODE_ALWAYS
	#
	hitbox.area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	move_and_collide(direction * speed * delta)

func _on_area_entered(_area: Area2D):
	hitbox.hit()
	
	#process_mode = Node.PROCESS_MODE_DISABLED
	
	#explosion.emitting = true
	#await explosion.finished
	queue_free.call_deferred()
