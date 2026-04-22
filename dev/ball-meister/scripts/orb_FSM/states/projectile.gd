extends OrbStateInterface
class_name OrbProjectileState

var _time_alive: float = 0.0

func enter(prev_state: String) -> void:
	_time_alive = 0.0

func update(delta: float) -> void:
	_time_alive += delta
	orb.global_position += orb.velocity_dir * orb.velocity_speed * delta
	if orb.projectile_lifetime > 0.0 and _time_alive >= orb.projectile_lifetime:
		orb.disintegrate()
