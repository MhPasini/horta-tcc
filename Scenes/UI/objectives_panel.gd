extends PanelContainer

const objective_node = preload("res://Scenes/UI/objective.tscn")

var objectives : Array[Objective] = []
var current_lvl : int

@onready var ObjData = ObjectiveData.new()
@onready var lvl_info = $VFlow/LvlInfo
@onready var list = $VFlow/List

func _ready():
	clear_list()
	ObjectiveManager.clear_data()
	load_objectives(0)

func clear_list() -> void:
	for obj in list.get_children():
		obj.queue_free()
	objectives.clear()

func load_objectives(ID:int) -> void:
	current_lvl = ID
	var objective_data = ObjData.DATA[ID]
	lvl_info.text = objective_data.title
	for objective in objective_data.objectives:
		var obj = objective_node.instantiate()
		obj.objective_info = objective.info
		obj.has_progression = objective.has_progression
		obj.steps = objective.steps
		if obj.has_progression:
			obj.progress_max = objective.progress_max
		obj.objective_completed.connect(_on_objective_completed)
		list.add_child(obj)
		objectives.append(obj)
	ObjectiveManager.objectives_list = objectives

func load_next_lvl() -> void:
	load_objectives(current_lvl + 1)

func _on_objective_completed():
	if objectives.all(func(element): return element.completed):
		print("Level completed")
		Events.level_completed.emit(current_lvl)

func reset_lvl() -> void:
	clear_list()
	ObjectiveManager.clear_data()
	load_objectives(current_lvl)
