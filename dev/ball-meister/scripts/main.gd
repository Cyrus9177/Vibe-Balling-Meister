extends Node2D

const ORB = preload("uid://q41ygbxki14i")


@onready var path_2d: Path2D = $Path2D
@onready var line_2d: Line2D = $Line2D


func _ready() -> void:
	var curve = path_2d.curve
	var baked_points = curve.get_baked_points()
	
	line_2d.points = baked_points
	curve.sample_baked()
	
	var new_orb: Orb = ORB.instantiate()
	add_child(new_orb)
	new_orb.path = path_2d
