extends Area2D
class_name Orb

@export var chain_speed: float = 100.0
@export var velocity_speed: float = 500.0
@export var projectile_lifetime: float = 3.0

var FSM: OrbFSM

var orb_colors: Array[Color] = [
	Color.RED,
	Color.BLUE,
	Color.YELLOW,
	Color.GREEN,
	Color.PURPLE,
	Color.ORANGE
]
var color: Color
var path: Path2D
var progress: float = 0.0

var velocity_dir: Vector2 = Vector2.ZERO

@onready var orb: Sprite2D = $Orb

func _init() -> void:
	color = orb_colors.pick_random()


func _ready() -> void:
	modulate = color
	FSM = OrbFSM.new()
	FSM.owner = self
	
	var idle_state: OrbIdleState = OrbIdleState.new()
	var in_chain_state: OrbInChainState = OrbInChainState.new()
	var projectile_state: OrbProjectileState = OrbProjectileState.new()
	
	FSM.add_state("idle", idle_state)
	FSM.add_state("in_chain", in_chain_state)
	FSM.add_state("projectile", projectile_state)
	
	FSM.set_initial_state("idle")
	
	#if path != null and not has_velocity:
		#global_position = path.curve.sample_baked(0.0)


func _process(delta: float) -> void:
	if FSM:
		FSM.update(delta)


func _physics_process(delta: float) -> void:
	if FSM:
		FSM.physics_update(delta)


#func _process(delta: float) -> void:
	#if not is_active:
		#return
	#
	## 🔹 If fired (projectile behavior)
	#if has_velocity:
		#global_position += velocity_dir * velocity_speed * delta
		#return
	#
	## 🔹 Otherwise follow path (chain behavior)
	#if path == null:
		#return
	#
	#var curve = path.curve
	#
	#progress += speed * delta
	#if progress >= curve.get_baked_length():
		#queue_free() # or deactivate if pooling
		#return
	#
	#global_position = curve.sample_baked(progress)


func fire(direction: Vector2, from: Vector2) -> void:
	global_position = from
	velocity_dir = direction.normalized()


func disintegrate() -> void:
	queue_free()
