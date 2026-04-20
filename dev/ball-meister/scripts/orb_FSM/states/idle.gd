extends OrbStateInterface
class_name OrbIdleState


func enter(prev_state: String) -> void:
	if orb.path != null:
		orb.global_position = orb.path.curve.sample_baked(orb.progress)
