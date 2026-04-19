extends Node2D
class_name Player



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.look_at(event.position)
