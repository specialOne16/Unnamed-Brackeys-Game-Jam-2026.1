extends Node

var source = ""

func change_scene(target: PackedScene, _source: String):
	source = _source
	get_tree().change_scene_to_packed.call_deferred(target)
