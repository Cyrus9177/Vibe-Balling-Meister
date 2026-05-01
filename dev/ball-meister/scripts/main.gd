extends Node2D

const ORB = preload("uid://q41ygbxki14i")

@export var orb_path: Path2D
@onready var orb_manager: OrbManager = $OrbManager
@onready var player: Player = $Player
@onready var _score_label: Label = $GameHUD/MarginContainer/PanelContainer/ScoreLabel
@onready var _status_label: Label = $GameHUD/MarginContainer2/StatusLabel

@export var orb_count: int

var _game_ended: bool = false

func _ready() -> void:
	if orb_path == null: return
	
	var curve = orb_path.curve
	var baked_points = curve.get_baked_points()
	
	if orb_manager:
		orb_manager.score_changed.connect(_on_score_changed)
		orb_manager.game_over.connect(_on_game_over)
		orb_manager.game_won.connect(_on_game_won)
		_on_score_changed(0)
		orb_manager.initialize_orbs(orb_count)


func _input(event: InputEvent) -> void:
	if _game_ended and event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE or event.keycode == KEY_R:
			_retry_game()
			get_tree().root.set_input_as_handled()


func _on_score_changed(new_score: int) -> void:
	if _score_label:
		_score_label.text = "Score: %d" % new_score


func _on_game_over() -> void:
	_game_ended = true
	_show_status("GAME OVER\n(Press SPACE or R to retry)")
	if player:
		player.set_process_input(false)


func _on_game_won() -> void:
	_game_ended = true
	_show_status("YOU WIN!\n(Press SPACE or R to retry)")
	if player:
		player.set_process_input(false)


func _show_status(text: String) -> void:
	if _status_label:
		_status_label.text = text
		_status_label.visible = true


func _retry_game() -> void:
	_game_ended = false
	_status_label.visible = false
	if orb_manager:
		orb_manager.initialize_orbs(orb_count)
	if player:
		player.set_process_input(true)
