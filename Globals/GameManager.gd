extends Node


var mode: String = "" # example: "start", "credit", etc.


func change_scene(scene_path: String) -> void:
	if ResourceLoader.exists(scene_path) == true:
		get_tree().change_scene_to_file(scene_path)
	else:
		print("Scena non trovata: " + scene_path)


func set_mode(new_mode: String) -> void:
	mode = new_mode
	
	if mode == "start":
		change_scene("res://Scenes/Level/Level.tscn")
	elif mode == "credit":
		change_scene("res://Scenes/Credit/Credit.tscn")
	elif mode == "menu":
		change_scene("res://Scenes/Main/Main.tscn")
