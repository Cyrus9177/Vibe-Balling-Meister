@tool
extends Path2D
class_name BallPath

@export_tool_button("Generate Path") var generate_path = _generate_paths
@export_tool_button("Reset") var reset = _reset_paths
var line2d: NodePath = "Line2D"

func _generate_paths() -> void:
	var line: Line2D = get_node(line2d)
	if line == null: return
	if curve.point_count <= 0: return
	
	line.clear_points()
	
	var points = curve.get_baked_points()
	for p in points:
		line.add_point(p)


func _reset_paths() -> void:
	var line: Line2D = get_node(line2d)
	if line == null: return
	
	line.clear_points()
	curve.clear_points()
