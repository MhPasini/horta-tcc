extends HBoxContainer
class_name Objective

@export var check_icons : Array[CompressedTexture2D]

var objective_info : String : set = _on_objective_info_set
var progress : int : set = _on_progress_set
var progress_max : int
var have_progression := false

@onready var check = $Check
@onready var label = $Label
@onready var progress_label = $ProgressLabel


func _ready():
	check.texture = check_icons[0]
	label.self_modulate = Color.WHITE
	if not have_progression:
		progress_label.hide()

func set_completed() -> void:
	check.texture = check_icons[1]
	label.self_modulate = Color.LIME_GREEN

func _on_objective_info_set(text:String) -> void:
	objective_info = text
	label.text = text

func _on_progress_set(value:int) -> void:
	progress = value
	progress_label.text = "(%d/%d)" % [progress, progress_max]
