extends Node2D
class_name Orb

@export var orb_color: Color = Color.WHITE
@export var speed: float = 100.0

var path: Path2D
var progress: float = 0.0

@onready var orb: Sprite2D = $Orb


func _ready() -> void:
	orb.modulate = orb_color


func _process(delta: float) -> void:
	if path == null:
		return
	
	var curve = path.curve
	
	progress += speed * delta
	global_position = curve.sample_baked(progress)
