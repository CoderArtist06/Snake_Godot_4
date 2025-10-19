extends Node

var score: int = 0
var score_data: ScoreData

const SAVE_PATH := "user://score_data.tres"

func _ready() -> void:
	load_high_score()

func add_points(points: int) -> void:
	score += points
	if score > score_data.high_score:
		score_data.high_score = score
		save_high_score()
		#print("New record:", score_data.high_score)

func reset_points() -> void:
	score = 0

func load_high_score() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var loaded = ResourceLoader.load(SAVE_PATH)
		if loaded is ScoreData:
			score_data = loaded
		else:
			score_data = ScoreData.new()
	else:
		score_data = ScoreData.new()
		save_high_score() # crea il file la prima volta

func save_high_score() -> void:
	ResourceSaver.save(score_data, SAVE_PATH)
