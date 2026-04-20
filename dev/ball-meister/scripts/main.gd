extends Node2D

const ORB = preload("uid://q41ygbxki14i")

@onready var orb_path: Path2D = %OrbPath
@onready var line_2d: Line2D = $Line2D
@onready var orb_manager: OrbManager = $OrbManager

@export var orb_count: int



func _ready() -> void:
	var curve = orb_path.curve
	var baked_points = curve.get_baked_points()
	line_2d.points = baked_points
	
	orb_manager.initialize_orbs(orb_count)
