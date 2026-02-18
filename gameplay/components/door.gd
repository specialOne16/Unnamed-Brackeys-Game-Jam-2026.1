extends Area2D
class_name Door

@export var current_scene_name: String
@export var target_scene: PackedScene

func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is TD2Player:
		LevelLoader.change_scene(target_scene, current_scene_name)
