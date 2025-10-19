extends CanvasLayer


signal restart

func _on_restart_button_pressed() -> void:
	restart.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Select") == true:
		_on_restart_button_pressed()
