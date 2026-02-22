extends Node

@onready var enemy_aggro: AudioStreamPlayer = %EnemyAggro
@onready var enemy_crossbow: AudioStreamPlayer = %EnemyCrossbow
@onready var enemy_death: AudioStreamPlayer = %EnemyDeath
@onready var fall: AudioStreamPlayer = %Fall
@onready var jump: AudioStreamPlayer = %Jump
@onready var chest_opening: AudioStreamPlayer = %ChestOpening
@onready var taking_item: AudioStreamPlayer = %TakingItem

@onready var steps: Node = %Steps
@onready var step_1: AudioStreamPlayer = %Step1
@onready var step_2: AudioStreamPlayer = %Step2
@onready var step_3: AudioStreamPlayer = %Step3
@onready var step_4: AudioStreamPlayer = %Step4
@onready var step_5: AudioStreamPlayer = %Step5
@onready var step_6: AudioStreamPlayer = %Step6

@onready var melee_no_impact: AudioStreamPlayer = %MeleeNoImpact
@onready var melee_with_impact: AudioStreamPlayer = %MeleeWithImpact
@onready var shot_1: AudioStreamPlayer = %Shot1
@onready var door_opening: AudioStreamPlayer = %DoorOpening
@onready var ending_iron_maden: AudioStreamPlayer = %EndingIronMaden
@onready var near_relics: AudioStreamPlayer = %NearRelics
@onready var player_taking_damage: AudioStreamPlayer = %PlayerTakingDamage
@onready var ambient_1: AudioStreamPlayer = %Ambient1
@onready var ambient_2: AudioStreamPlayer = %Ambient2
@onready var ambient_3: AudioStreamPlayer = %Ambient3
@onready var artifact_1: AudioStreamPlayer = %Artifact1
@onready var artifact_2: AudioStreamPlayer = %Artifact2
@onready var battle_ambient_loop_final: AudioStreamPlayer = %BattleAmbientLoopFinal
@onready var main_loop_final: AudioStreamPlayer = %MainLoopFinal
@onready var charged: AudioStreamPlayer = %Charged
@onready var charging: AudioStreamPlayer = %Charging
@onready var heal_2: AudioStreamPlayer = %Heal2
@onready var looting_ammo: AudioStreamPlayer = %LootingAmmo
@onready var looting_package: AudioStreamPlayer = %LootingPackage

var active_theme: AudioStreamPlayer

func _ready() -> void:
	var songs: Array[AudioStreamPlayer] = [%Ambient1, %Ambient2, %Ambient3, %Artifact1, %Artifact2, %BattleAmbientLoopFinal, %MainLoopFinal]
	for song in songs:
		song.finished.connect(func(): song.play())

func change_theme(new_name: String):
	var new_theme = find_child(new_name)
	
	if new_theme == null:
		if active_theme: active_theme.stop()
		return
	if active_theme == new_theme: return
	
	if active_theme:
		active_theme.stop()
	
	active_theme = new_theme
	active_theme.play()
