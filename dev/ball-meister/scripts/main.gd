extends Node2D

const ORB = preload("uid://q41ygbxki14i")

@onready var orb_path: Path2D = %OrbPath
@onready var line_2d: Line2D = $Line2D
@onready var orb_manager: OrbManager = $OrbManager
@onready var player: Player = $Player

@export var orb_count: int

var _score_label: Label
var _status_label: Label

func _ready() -> void:
	var curve = orb_path.curve
	var baked_points = curve.get_baked_points()
	line_2d.points = baked_points
	
	_setup_ui()
	if orb_manager:
		orb_manager.score_changed.connect(_on_score_changed)
		orb_manager.game_over.connect(_on_game_over)
		orb_manager.game_won.connect(_on_game_won)
		_on_score_changed(0)
		orb_manager.initialize_orbs(orb_count)


func _setup_ui() -> void:
	var ui_layer := CanvasLayer.new()
	ui_layer.name = "UI"
	add_child(ui_layer)

	_score_label = Label.new()
	_score_label.name = "ScoreLabel"
	_score_label.text = "Score: 0"
	_score_label.position = Vector2(10, 10)
	_score_label.add_theme_font_size_override("font_size", 32)
	_score_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(_score_label)

	_status_label = Label.new()
	_status_label.name = "StatusLabel"
	_status_label.visible = false
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_status_label.anchor_left = 0.0
	_status_label.anchor_top = 0.0
	_status_label.anchor_right = 1.0
	_status_label.anchor_bottom = 1.0
	_status_label.add_theme_font_size_override("font_size", 64)
	_status_label.add_theme_color_override("font_color", Color.WHITE)
	_status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(_status_label)


func _on_score_changed(new_score: int) -> void:
	if _score_label:
		_score_label.text = "Score: %d" % new_score


func _on_game_over() -> void:
	_show_status("GAME OVER")
	if player:
		player.set_process_input(false)


func _on_game_won() -> void:
	_show_status("YOU WIN!")
	if player:
		player.set_process_input(false)


func _show_status(text: String) -> void:
	if _status_label:
		_status_label.text = text
		_status_label.visible = true
