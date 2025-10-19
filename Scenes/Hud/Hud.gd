extends CanvasLayer


@onready var label: Label = $Label


func score_label_modifier (points: int) -> void:
	label.text = "Score: " + str(points)
