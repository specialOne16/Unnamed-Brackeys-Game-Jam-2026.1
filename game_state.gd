extends Node

var died_enemy_ids: Array[String] = []
var opened_chest: Array[String] = []
var collected_chest: Array[String] = []
var player_health: float = INF

var shotgun_ammo = 0
var health_pack = 0

var checkpoint_path: String = ""
var checkpoint_spawn: String = ""

var relic_1_collected = false
var relic_2_collected = false

func gain_item(item: GroundItem.Type) -> bool:
	match item:
		GroundItem.Type.HEALTH_PACK:
			health_pack += 1
		GroundItem.Type.SHOTGUN_AMMO:
			shotgun_ammo += 1
		GroundItem.Type.RELIC_1: 
			relic_1_collected = true
		GroundItem.Type.RELIC_2:
			relic_2_collected = true
	
	return true

func has_health_pack(): return health_pack > 0
func use_health_pack() -> bool:
	health_pack -= 1
	return true

func has_shotgun_ammo() -> bool:
	return shotgun_ammo > 0

func use_shotgun_ammo() -> bool:
	shotgun_ammo -= 1
	return true

func respawn():
	player_health = INF
	shotgun_ammo = 0
	health_pack = 0
	
	LevelLoader.change_scene(checkpoint_path, checkpoint_spawn)
