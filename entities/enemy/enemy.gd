extends CharacterBody2D
class_name Enemy

const LIGHT_ONLY = preload("uid://bnu2oiso3alir")

@export var id: String
@export var max_health: float = 30
@export var movement_speed: float = 50
@export var player_detection_range: float = 50
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

signal enemy_died(enemy: Enemy)

var player: TD2Player
var current_health: float
var movement_override: Node
var aggresive: bool = false
var fleeing: bool = false

func override_movement(node: Node) -> bool:
	if movement_override == null:
		movement_override = node
		return true
	
	if movement_override == node:
		return true
	
	return false

func unoverride_movement(node):
	if movement_override == node:
		movement_override = null

func _ready() -> void:
	if GameState.died_enemy_ids.has(id): queue_free()
	animated_sprite_2d.material = LIGHT_ONLY

func died():
	if id != "": GameState.died_enemy_ids.append(id)
	enemy_died.emit(self)
	queue_free()
