extends Node
class_name OrbManager

const ORB = preload("uid://q41ygbxki14i")

var orb_pool: Array[Orb]


@export var orb_path: Path2D


func _ready() -> void:
	pass


func initialize_orbs(orb_count: int = 0) -> void:
	var interval: int = 0
	
	for i in orb_count:
		var orb: Orb = ORB.instantiate()
		orb.path = orb_path
		get_tree().current_scene.add_child(orb)
		orb.progress = interval
		orb_pool.append(orb)
		
		interval += 70
		orb.FSM.change_state("in_chain")
	
	sort_orb_pool()


func sort_orb_pool() -> void:
	orb_pool.sort_custom(func(a, b):
		return a.progress > b.progress
	)


func _on_orb_hit(area: Area2D, orb: Orb) -> void:
	if orb_pool.find(area) == 0:
		hit_from_front(area, orb)
	elif orb_pool.find(area) == orb_pool.size() -1:
		hit_from_back(area, orb)
	else:
		hit_from_middle(area, orb)


func hit_from_back(hit_orb: Orb, projectile: Orb) -> void:
	#print("Orb hit from back ", hit_orb.color)
	projectile.disconnect("area_entered", Callable(self, "_on_orb_hit"))
	
	for o in orb_pool:
		o.FSM.change_state("idle")
	projectile.FSM.change_state("idle")
	
	var orb_next: Orb = orb_pool.get(orb_pool.size() - 2)
	
	var projectile_pos: Vector2 = projectile.global_position
	var hit_orb_pos: Vector2 = hit_orb.global_position
	var orb_next_pos: Vector2 = orb_next.global_position
	
	if orb_next_pos.distance_to(projectile_pos) < 85.0:
		projectile.path = orb_path
		orb_pool.append(projectile)
		projectile.progress = hit_orb.progress
		hit_orb.progress -= 70
	else:
		projectile.path = orb_path
		orb_pool.append(projectile)
		projectile.progress += hit_orb.progress - 70
	
	continue_chain(projectile)


func hit_from_front(hit_orb: Orb, projectile: Orb) -> void:
	#print("Orb hit from front ", hit_orb.color)
	projectile.disconnect("area_entered", Callable(self, "_on_orb_hit"))
	
	for o in orb_pool:
		o.FSM.change_state("idle")
	projectile.FSM.change_state("idle")
	
	var orb_next: Orb = orb_pool.get(1)
	
	var projectile_pos: Vector2 = projectile.global_position
	var hit_orb_pos: Vector2 = hit_orb.global_position
	var orb_next_pos: Vector2 = orb_next.global_position
	
	if orb_next_pos.distance_to(projectile_pos) < 85.0:
		projectile.path = orb_path
		orb_pool.append(projectile)
		projectile.progress = hit_orb.progress
		hit_orb.progress += 70
	else:
		projectile.path = orb_path
		orb_pool.append(projectile)
		projectile.progress += hit_orb.progress + 70
	
	continue_chain(projectile)
	

func hit_from_middle(hit_orb: Orb, projectile: Orb) -> void:
	#print("Orb hit from middle ", hit_orb.color)
	projectile.disconnect("area_entered", Callable(self, "_on_orb_hit"))
	
	for o in orb_pool:
		o.FSM.change_state("idle")
	#projectile.FSM.change_state("idle")
	
	var hit_idx: int = orb_pool.find(hit_orb)
	var left_side_orb: Orb = orb_pool.get(hit_idx - 1)
	var right_side_orb: Orb = orb_pool.get(hit_idx + 1)
	
	var left_pos: Vector2 = left_side_orb.global_position
	var right_pos: Vector2 = right_side_orb.global_position
	var projectile_pos: Vector2 = projectile.global_position
	
	if left_pos.distance_to(projectile_pos) > 85.0:
		projectile.path = orb_path
		orb_pool.append(projectile)
		projectile.progress = hit_orb.progress
		for i in range(hit_idx, -1, -1):
			orb_pool.get(i).progress += 70
	else:
		projectile.path = orb_path
		orb_pool.append(projectile)
		projectile.progress = hit_orb.progress +70
		for i in range(hit_idx, orb_pool.size()):
			orb_pool.get(i).progress -= 70
	
	continue_chain(projectile)


func continue_chain(orb: Orb) -> void:
	sort_orb_pool()
	if has_match_colors(orb):
		for o in orb_pool:
			o.FSM.change_state("idle")
		
		var gaps: Array = get_all_gaps()
		for g in gaps:
			var head_idx: int = orb_pool.find(g[0])
			
			for i in range(head_idx, -1, -1):
				var o: Orb = orb_pool.get(i)
				var new_progress = orb_pool.get(i+1).progress + 70
				o.progress = new_progress
		for o in orb_pool:
			o.FSM.change_state("in_chain")
	else:
		for o in orb_pool:
			o.FSM.change_state("in_chain")


func get_all_gaps(step: float = 70.0, tolerance: float = 1.0) -> Array:
	var gaps: Array = []
	
	for i in range(orb_pool.size() - 1):
		var a = orb_pool[i]
		var b = orb_pool[i + 1]
		if abs((a.progress - b.progress) - step) > tolerance:
			gaps.append([a, b])
	
	return gaps


func has_match_colors(from_orb: Orb) -> bool:
	var idx: int = orb_pool.find(from_orb)
	var orb_color: Color = from_orb.color
	var matched_orbs: Array[Orb]
	
	for i in range(idx, -1, -1):
		var _orb: Orb = orb_pool.get(i)
		if _orb.color == orb_color:
			matched_orbs.append(_orb)
		else:
			break
	
	for i in range(idx, orb_pool.size()):
		var _orb: Orb = orb_pool.get(i)
		if _orb.color == orb_color:
			matched_orbs.append(_orb)
		else:
			break
	
	if matched_orbs.size() > 3:
		print("found matching colors of more than 3")
		for orb in matched_orbs:
			orb_pool.erase(orb)
			orb.disintegrate()
		return true
	return false
