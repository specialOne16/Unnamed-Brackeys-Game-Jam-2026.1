extends Node

var died_enemy_ids: Array[String] = []
var opened_chest: Array[String] = []
var collected_chest: Array[String] = []
var player_health: float = INF

var inventory_1
var inventory_2

var checkpoint_path: String = ""
var checkpoint_spawn: String = ""

var relic_1_collected = false
var relic_2_collected = false

func gain_item(item: GroundItem.Type) -> bool:
	match item:
		GroundItem.Type.HEALTH_PACK, GroundItem.Type.SHOTGUN_AMMO:
			if inventory_1 == null:
				inventory_1 = item
				return true
			elif inventory_2 == null:
				inventory_2 = item
				return true
			else:
				return false
		GroundItem.Type.RELIC_1: 
			relic_1_collected = true
			return true
		GroundItem.Type.RELIC_2:
			relic_2_collected = true
			return true
	
	return false

func has_health_pack(): return inventory_1 == GroundItem.Type.HEALTH_PACK or inventory_2 == GroundItem.Type.HEALTH_PACK
func use_health_pack() -> bool:
	if inventory_1 == GroundItem.Type.HEALTH_PACK:
		inventory_1 = null
		return true
	elif inventory_2 == GroundItem.Type.HEALTH_PACK:
		inventory_2 = null
		return true
	
	return false

func has_shotgun_ammo():
	return (
		inventory_1 == GroundItem.Type.SHOTGUN_AMMO or inventory_1 == GroundItem.Type.HALF_SHOTGUN_AMMO
	) or (
		inventory_2 == GroundItem.Type.SHOTGUN_AMMO or inventory_2 == GroundItem.Type.HALF_SHOTGUN_AMMO
	)

func use_shotgun_ammo() -> bool:
	if inventory_1 == GroundItem.Type.HALF_SHOTGUN_AMMO:
		inventory_1 = null
		return true
	elif inventory_2 == GroundItem.Type.HALF_SHOTGUN_AMMO:
		inventory_2 = null
		return true
	elif inventory_1 == GroundItem.Type.SHOTGUN_AMMO:
		inventory_1 = GroundItem.Type.HALF_SHOTGUN_AMMO
		return true
	elif inventory_2 == GroundItem.Type.SHOTGUN_AMMO:
		inventory_2 = GroundItem.Type.HALF_SHOTGUN_AMMO
		return true
	
	return false

func respawn():
	player_health = INF
	inventory_1 = null
	inventory_2 = null
	
	LevelLoader.change_scene(checkpoint_path, checkpoint_spawn)
