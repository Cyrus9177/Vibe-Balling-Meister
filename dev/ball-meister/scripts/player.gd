extends Node2D
class_name Player

const ORB = preload("uid://q41ygbxki14i")

@onready var handed_orb: Sprite2D = $Body/HandedOrb
@onready var next_orb_color: Sprite2D = $Body/NextOrbColor
@onready var orb_spawn_point: Marker2D = $OrbSpawnPoint

@export var orb_manager: OrbManager

var orb_pool: Array[Orb]

func _ready() -> void:
	for i in range(2):
		var initial_orb: Orb = ORB.instantiate()
		orb_pool.append(initial_orb)
	
	handed_orb.modulate = orb_pool.front().color

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.look_at(event.global_position)
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				var next_orb: Orb = ORB.instantiate()
				orb_pool.append(next_orb)
				next_orb_color.modulate = orb_pool.back().color
				fire_orb(event.global_position, orb_pool.pop_front())
				handed_orb.modulate = orb_pool.front().color
		
		# Switch Color
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_released():
				if orb_pool.size() > 1:
					var temp = orb_pool.pop_front()
					orb_pool.append(temp)
					
					handed_orb.modulate = orb_pool.front().color
					next_orb_color.modulate = orb_pool.back().color

func get_orb_spawn_point() -> Vector2:
	return orb_spawn_point.global_position


func fire_orb(mouse_pos: Vector2, orb: Orb = null) -> void:
	if orb == null:
		return
	get_tree().current_scene.add_child(orb)
	
	orb.FSM.change_state("projectile")
	orb.fire(mouse_pos - self.global_position, get_orb_spawn_point())
	if orb_manager:
		orb.connect("area_entered", Callable(orb_manager, "_on_orb_hit").bind(orb))
