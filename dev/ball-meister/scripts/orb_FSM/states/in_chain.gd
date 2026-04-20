extends OrbStateInterface
class_name OrbInChainState


func enter(prev_state: String) -> void:
	pass


func update(delta: float) -> void:
	if orb.path == null:
		return
	
	orb.progress += orb.chain_speed * delta
	
	var curve = orb.path.curve
	
	orb.global_position = curve.sample_baked(orb.progress)
	
