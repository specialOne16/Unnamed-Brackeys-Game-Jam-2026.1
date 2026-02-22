extends StaticBody2D
class_name GroundItem

enum Type { RELIC_1, RELIC_2, HEALTH_PACK, SHOTGUN_AMMO, HALF_SHOTGUN_AMMO }

const RELICS = preload("uid://bwvgvv5mbvj7c")
const UI_CONSUMABLES_I = preload("uid://dky00adsgbg5i")

@onready var pickup_area: Area2D = $PickupArea
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var id: String
@export var type: Type
@export var play_relic_sound: bool = true

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

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body is TD2Player:
		if GameState.gain_item(type):
			if id != "": GameState.collected_chest.append(id)
			AudioPlayer.taking_item.play()
			queue_free()

func _on_relic_sound_area_body_entered(body: Node2D) -> void:
	if body is TD2Player and not AudioPlayer.near_relics.playing:
		AudioPlayer.near_relics.play()
