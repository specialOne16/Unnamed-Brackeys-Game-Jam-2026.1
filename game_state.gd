extends Node

var died_enemy_ids: Array[String] = []
var player_health: float = INF
var shotgun: int = 0
var healing_pack: int = 0

var checkpoint_path: String = ""
var checkpoint_spawn: String = ""

func gain_item(item: Chest.Item):
	match item:
		Chest.Item.HEALTH_PACK: healing_pack += 1
		Chest.Item.SHOTGUN_AMMO: shotgun += 1

func respawn():
	died_enemy_ids = []
	player_health = INF
	shotgun = 0
	healing_pack = 0
	
	LevelLoader.change_scene(checkpoint_path, checkpoint_spawn)
