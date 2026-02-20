extends Node2D

const PLAYER = preload("uid://iggh13u56wx8")
const IN_GAME_UI = preload("uid://ccgswg3ymqkwg")
const DARK_OVERLAY = preload("uid://c3gq6kvbs1q0c")

var _player: TD2Player
var _in_game_ui: InGameUi

func _ready() -> void:
	var spawn_point: SpawnPoint = null
	_player = PLAYER.instantiate()
	
	for node in get_children():
		if node is SpawnPoint:
			if spawn_point == null:
				if node.previous_scene_name == "": 
					spawn_point = node
			
			if node.previous_scene_name == LevelLoader.source:
				spawn_point = node
		
		if node is Door:
			node.change_scene.connect(_change_scene)
		
		if node is MeleeEnemy:
			node.player = _player
		
		if node is RangedEnemy:
			node.player = _player
	
	if spawn_point:
		_player.position = spawn_point.position
		_player.rotation = spawn_point.spawn_direction.angle()
		add_child(_player)
	
	_in_game_ui = IN_GAME_UI.instantiate()
	add_child(_in_game_ui)
	
	add_child(DARK_OVERLAY.instantiate())
	
	_in_game_ui.scene_transition_in()

func _change_scene(target_scene_path: String, current_scene_name: String):
	await _in_game_ui.scene_transition_out()
	LevelLoader.change_scene(target_scene_path, current_scene_name)
