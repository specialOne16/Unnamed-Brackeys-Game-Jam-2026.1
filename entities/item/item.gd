extends StaticBody2D
class_name GroundItem

enum Type { RELIC_1, RELIC_2, HEALTH_PACK, SHOTGUN_AMMO, HALF_SHOTGUN_AMMO }

const RELICS = preload("uid://bwvgvv5mbvj7c")
const UI_CONSUMABLES_I = preload("uid://dky00adsgbg5i")

@onready var pickup_area: Area2D = $PickupArea
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var id: String
@export var type: Type

func _ready() -> void:
	match type:
		Type.RELIC_1:
			sprite_2d.texture = RELICS
			sprite_2d.hframes = 3
			sprite_2d.frame = 1
		Type.RELIC_2:
			sprite_2d.texture = RELICS
			sprite_2d.hframes = 3
			sprite_2d.frame = 0
		Type.HEALTH_PACK:
			sprite_2d.texture = UI_CONSUMABLES_I
			sprite_2d.hframes = 4
			sprite_2d.vframes = 3
			sprite_2d.frame = 4
		Type.SHOTGUN_AMMO:
			sprite_2d.texture = UI_CONSUMABLES_I
			sprite_2d.hframes = 4
			sprite_2d.vframes = 3
			sprite_2d.frame = 5

func _process(_delta: float) -> void:
	if pickup_area.has_overlapping_bodies():
		if Input.is_action_just_pressed("interact"):
			if GameState.gain_item(type):
				if id != "": GameState.collected_chest.append(id)
				queue_free()
