extends Node2D

const PLAYER = preload("uid://iggh13u56wx8")
const IN_GAME_UI = preload("uid://ccgswg3ymqkwg")
const DARK_OVERLAY = preload("uid://c3gq6kvbs1q0c")
const WIN_UI = preload("uid://0mmjdavrjgs2")

@export var is_combat_room: bool = false
@export var checkpoint_path: String
@export var checkpoint_spawn: String
@export var ambient: String

var _player: TD2Player
var _in_game_ui: InGameUi
var _win_ui: WinUi
var _coffin: Coffin
var _dark_overlay: CanvasModulate
var _alive_enemies: int = 0

func _ready() -> void:
	var spawn_point: SpawnPoint = null
	_player = PLAYER.instantiate()
	_in_game_ui = IN_GAME_UI.instantiate()
	_win_ui = WIN_UI.instantiate()
	
	_player.dead.connect(_dead)
	
	for node in get_children():
		if node is SpawnPoint:
			if spawn_point == null:
				if node.previous_scene_name == "": 
					spawn_point = node
			
			if node.previous_scene_name == LevelLoader.source:
				spawn_point = node
		
		if node is Door:
			node.change_scene.connect(_change_scene)
		
		if node is Enemy:
			node.player = _player
			node.enemy_died.connect(_enemy_died)
			if not GameState.died_enemy_ids.has(node.id):
				_alive_enemies += 1
		
		if node is Chest:
			if GameState.collected_chest.has(node.id):
				node.open_chest(false, false)
			elif GameState.opened_chest.has(node.id):
				node.open_chest(true, false)
		
		if node is GroundItem:
			if GameState.collected_chest.has(node.id):
				node.queue_free()
		
		if node is Coffin:
			_coffin = node
			_coffin.coffin_entered.connect(_win)
	
	if is_combat_room and _alive_enemies > 0:
		_player.set_collision_mask_value(8, true)
	
	if spawn_point:
		_player.position = spawn_point.position
		_player.rotation = spawn_point.spawn_direction.angle()
		add_child(_player)
		
		if checkpoint_path != "":
			GameState.checkpoint_path = checkpoint_path
			if checkpoint_spawn != "":
				GameState.checkpoint_spawn = checkpoint_spawn
			else:
				GameState.checkpoint_spawn = spawn_point.previous_scene_name
	
	add_child(_in_game_ui)
	add_child(_win_ui)
	_in_game_ui.set_player_health(_player.max_health)
	
	_dark_overlay = DARK_OVERLAY.instantiate()
	add_child(_dark_overlay)
	
	AudioPlayer.change_theme(ambient)
	_in_game_ui.scene_transition_in()

func _enemy_died(_enemy: Enemy):
	_alive_enemies -= 1
	if _alive_enemies <= 0:
		_player.set_collision_mask_value(8, false)

func _change_scene(door: Door):
	if is_combat_room and _alive_enemies > 0: return
	
	door.open_the_door()
	await _in_game_ui.scene_transition_out()
	if door.relic_2_target_scene_path == "":
		LevelLoader.change_scene(door.target_scene_path, door.current_scene_name)
	else:
		if GameState.relic_2_collected:
			LevelLoader.change_scene(door.relic_2_target_scene_path, door.current_scene_name)
		else:
			LevelLoader.change_scene(door.target_scene_path, door.current_scene_name)

func _dead():
	await _in_game_ui.scene_transition_out()
	GameState.respawn()

func _win():
	_player.z_index = 3
	_coffin.z_index = 3
	
	_win_ui.global_position = _coffin.global_position
	
	get_tree().paused = true
	_player.lights.visible = false
	_dark_overlay.color = Color.WHITE
	_in_game_ui.visible = false
	await _win_ui.play()
	_player.visible = false
	_coffin.visible = false
