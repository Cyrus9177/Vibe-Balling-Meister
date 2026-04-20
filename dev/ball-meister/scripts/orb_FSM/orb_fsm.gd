extends StateMachine
class_name OrbFSM


func add_state(state_name: String, state: OrbStateInterface) -> void:
	states[state_name] = state
	state.state_machine = self
	state.orb = owner
