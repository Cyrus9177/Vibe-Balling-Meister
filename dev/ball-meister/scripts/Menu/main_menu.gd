extends CanvasLayer


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("uid://b5rxi7gunv6aq"))


func _on_quit_button_pressed() -> void:
	get_tree().quit()
