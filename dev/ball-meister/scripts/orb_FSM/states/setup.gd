extends OrbStateInterface
class_name OrbSetupState


func enter(prev_state: String) -> void:
	#print(orb.progress)
	pass


func update(delta: float) -> void:
	if orb.path == null:
		return
	
	var curve = orb.path.curve
	
	orb.global_position = curve.sample_baked(orb.progress)
	
