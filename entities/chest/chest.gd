extends StaticBody2D
class_name Chest

enum Item { HEALTH_PACK, SHOTGUN_AMMO }

@export var id: String
@export var item: Item = Item.SHOTGUN_AMMO

func _on_hurtbox_2d_take_damage(_source: HitBox2D) -> void:
	GameState.gain_item(item)
	queue_free()
