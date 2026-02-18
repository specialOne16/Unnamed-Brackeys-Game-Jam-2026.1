extends Node2D

const PLAYER = preload("uid://iggh13u56wx8")
const DARK_OVERLAY = preload("uid://c3gq6kvbs1q0c")

func _ready() -> void:
	var spawn_point: SpawnPoint = null
	
	for node in get_children():
		if not node is SpawnPoint: continue
		
		if spawn_point == null:
			if node.previous_scene_name == "": 
				spawn_point = node
		
		if node.previous_scene_name == LevelLoader.source:
			spawn_point = node
	
	if spawn_point:
		var player = PLAYER.instantiate()
		player.position = spawn_point.position
		player.rotation = spawn_point.spawn_direction.angle()
		add_child(player)
	
	add_child(DARK_OVERLAY.instantiate())
