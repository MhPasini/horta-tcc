extends HBoxContainer
class_name Objective

@export var check_icons : Array[CompressedTexture2D]

var objective_info : String
var progress : int : set = _on_progress_set
var progress_max : int
var has_progression := false
var completed : bool = false
var steps = []

@onready var check = $Check
@onready var label = $Label
@onready var progress_label = $ProgressLabel

signal objective_completed

func _ready():
	check.texture = check_icons[0]
	label.self_modulate = Color.WHITE
	label.text = objective_info
	progress = 0
	if not has_progression:
		progress_label.hide()

func set_completed() -> void:
	completed = true
	objective_completed.emit()
	check.texture = check_icons[1]
	label.self_modulate = Color.LIME_GREEN
	progress_label.self_modulate = Color.LIME_GREEN

func _on_progress_set(value:int) -> void:
	progress = value
	progress_label.text = "(%d/%d)" % [progress, progress_max]

func complete_step(step) -> void:
	step.completed = true
	if step.progress_step:
		progress += 1
	print(step.type, " ", step.target, " completed")
	if steps.all(func(element): return element.completed):
		print("objective completed")
		set_completed()
