extends Area2D
class_name Door

const DOOR_SPRITE = preload("uid://cvix6p57sjjo8")

signal change_scene(door: Door)

@export var current_scene_name: String
@export var target_scene_path: String
@export var relic_2_target_scene_path: String
@export var asset_size: int = 16
@export var is_horizontal: bool = true

var sprite: AnimatedSprite2D

func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	
	body_entered.connect(_on_body_entered)
	
	sprite = DOOR_SPRITE.instantiate()
	sprite.animation = "closed_%d" % asset_size
	add_child(sprite)
	
	if not is_horizontal:
		sprite.rotation = PI / 2

func _on_body_entered(body: Node2D) -> void:
	if body is TD2Player:
		change_scene.emit(self)

func open_the_door():
	if sprite.animation == "closed_%d" % asset_size:
		sprite.play("opening_%d" % asset_size)
