extends OrbStateInterface
class_name OrbProjectileState


func enter(prev_state: String) -> void:
	#print("Projectile State Entered")
	pass


func update(delta: float) -> void:
	orb.global_position += orb.velocity_dir * orb.velocity_speed * delta
