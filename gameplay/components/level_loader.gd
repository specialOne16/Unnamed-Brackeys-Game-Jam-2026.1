extends Node

var source = ""

func change_scene(target: String, _source: String):
	source = _source
	get_tree().change_scene_to_file.call_deferred(target)
