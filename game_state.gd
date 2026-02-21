extends Node

var died_enemy_ids: Array[String] = []
var player_health: float = INF
var shotgun: int = 0
var healing_pack: int = 0

func gain_item(item: Chest.Item):
	match item:
		Chest.Item.HEALTH_PACK: healing_pack += 1
		Chest.Item.SHOTGUN_AMMO: shotgun += 1
