extends CanvasLayer


signal restart


func _on_restart_button_pressed() -> void:
	restart.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit") == true:
		get_tree().paused = false
		GameManager.set_mode("menu")
