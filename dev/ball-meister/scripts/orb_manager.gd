extends Node
class_name OrbManager

signal score_changed(new_score: int)
signal game_over
signal game_won

const ORB = preload("uid://q41ygbxki14i")

var orb_pool: Array[Orb] = []
var score: int = 0
var _game_active: bool = true

@export var orb_path: Path2D
@export var points_per_orb: int = 10
@export var end_progress_margin: float = 50.0

func _ready() -> void:
	score_changed.emit(score)

func _process(_delta: float) -> void:
	if not _game_active or orb_path == null or orb_path.curve == null:
		return
	
	_prune_invalid_orbs()
	if orb_pool.is_empty():
		_end_game(true)
		return

	sort_orb_pool()
	var front_orb: Orb = orb_pool[0]
	var curve_len: float = orb_path.curve.get_baked_length()
	if front_orb.progress >= (curve_len - end_progress_margin):
		_end_game(false)

func is_game_active() -> bool:
	return _game_active


func initialize_orbs(orb_count: int = 0) -> void:
	_game_active = true
	score = 0
	score_changed.emit(score)
	
	for o in orb_pool:
		if is_instance_valid(o):
			o.queue_free()
	orb_pool.clear()
	
	var interval: float = 0.0
	
	for i in range(orb_count):
		var orb: Orb = ORB.instantiate()
		orb.path = orb_path
		orb.progress = interval
		get_tree().current_scene.add_child(orb)
		orb_pool.append(orb)
		
		interval += 70.0
		orb.FSM.change_state("in_chain")
	
	sort_orb_pool()


func sort_orb_pool() -> void:
	orb_pool.sort_custom(func(a, b):
		return a.progress > b.progress
	)


func _on_orb_hit(area: Area2D, orb: Orb) -> void:
	if not _game_active or not is_instance_valid(orb) or not (area is Orb):
		return
	
	var hit_orb: Orb = area as Orb
	var hit_idx: int = orb_pool.find(hit_orb)
	if hit_idx == -1:
		return
	
	_disconnect_projectile_hit_signal(orb)
	_freeze_chain()
	orb.FSM.change_state("idle")
	
	if hit_idx == 0:
		hit_from_front(hit_orb, orb)
	elif hit_idx == orb_pool.size() - 1:
		hit_from_back(hit_orb, orb)
	else:
		hit_from_middle(hit_orb, orb)


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
	if idx == -1:
		return false
	
	var bounds: Vector2i = _get_match_bounds(idx)
	var match_size: int = bounds.y - bounds.x + 1
	
	if match_size >= 3:
		for i in range(bounds.y, bounds.x - 1, -1):
			var matched: Orb = orb_pool[i]
			orb_pool.remove_at(i)
			matched.disintegrate()
		
		score += match_size * points_per_orb
		score_changed.emit(score)
		_collapse_chain()
		return true
	return false

func _get_match_bounds(idx: int) -> Vector2i:
	var color: Color = orb_pool[idx].color
	var start_idx: int = idx
	var end_idx: int = idx
	
	while start_idx > 0 and orb_pool[start_idx - 1].color == color:
		start_idx -= 1
	while end_idx < orb_pool.size() - 1 and orb_pool[end_idx + 1].color == color:
		end_idx += 1
	
	return Vector2i(start_idx, end_idx)

func _collapse_chain() -> void:
	sort_orb_pool()
	if orb_pool.size() < 2:
		return
	for i in range(orb_pool.size() - 2, -1, -1):
		var behind: Orb = orb_pool[i + 1]
		orb_pool[i].progress = behind.progress + 70.0

func _freeze_chain() -> void:
	for o in orb_pool:
		o.FSM.change_state("idle")

func _disconnect_projectile_hit_signal(projectile: Orb) -> void:
	var c: Callable = Callable(self, "_on_orb_hit").bind(projectile)
	if projectile.is_connected("area_entered", c):
		projectile.disconnect("area_entered", c)

func _prune_invalid_orbs() -> void:
	for i in range(orb_pool.size() - 1, -1, -1):
		if not is_instance_valid(orb_pool[i]):
			orb_pool.remove_at(i)

func _end_game(won: bool) -> void:
	if not _game_active:
		return
	_game_active = false
	for o in orb_pool:
		if is_instance_valid(o) and o.FSM:
			o.FSM.change_state("idle")
	if won:
		game_won.emit()
	else:
		game_over.emit()
