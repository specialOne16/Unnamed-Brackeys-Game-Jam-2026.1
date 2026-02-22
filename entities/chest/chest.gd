extends StaticBody2D
class_name Chest

enum Item { HEALTH_PACK, SHOTGUN_AMMO }

const ITEM = preload("uid://d2r4arw47toyq")

@export var id: String
@export var item: Item = Item.SHOTGUN_AMMO

func _on_hurtbox_2d_take_damage(_source: HitBox2D) -> void:
	if id != "": GameState.opened_chest.append(id)
	open_chest(true, true)

func open_chest(has_item: bool, immediate_pickup: bool):
	var ground_item: GroundItem.Type
	match item:
		Item.HEALTH_PACK: ground_item = GroundItem.Type.HEALTH_PACK
		Item.SHOTGUN_AMMO: ground_item = GroundItem.Type.SHOTGUN_AMMO
	
	if has_item:
		var picked_up = false
		if immediate_pickup:
			picked_up = GameState.gain_item(ground_item)
		
		if picked_up:
			if id != "": GameState.collected_chest.append(id)
		if not picked_up:
			var item_instance: GroundItem = ITEM.instantiate()
			item_instance.type = ground_item
			item_instance.position = position
			add_sibling(item_instance)
		
	queue_free()
