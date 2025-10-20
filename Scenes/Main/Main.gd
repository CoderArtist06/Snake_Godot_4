extends Control


@onready var best_score_label: Label = $BestScoreLabel


func _ready() -> void:
	best_score_label.text = "best score: " + str(ScoreManager.score_data.high_score)


func _on_play_pressed() -> void:
	pass # Replace with function body.


func _on_credit_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	pass # Replace with function body.
