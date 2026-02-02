extends PanelContainer

const objective_node = preload("res://Scenes/UI/objective.tscn")
const questTipPanel = preload("res://Scenes/UI/quest_tip.tscn")
const lv_popup = preload("res://Scenes/Game/lv_popup.tscn")

var objectives : Array[Objective] = []
var objData : ObjectiveData
var current_lvl : int
var tip_text : String = ""

@onready var lvl_info = $VFlow/LvlInfo
@onready var list = $VFlow/List

func _ready():
	clear_list()
	ObjectiveManager.clear_data()
	objData = ObjectiveData.new()
	load_objectives(Globals.level_selected)
	Globals.objectives_panel = self
	Events.tutorial_completed.connect(_on_tutorial_completed)

func clear_list() -> void:
	for obj in list.get_children():
		obj.queue_free()
	objectives.clear()

func load_objectives(ID:int) -> void:
	current_lvl = ID
	Globals.level_selected = ID
	var objective_data = objData.DATA[ID]
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
	load_grid_state(objective_data)
	tip_text = objective_data.tip
	if !Globals.tutorial_on:
		show_popup(objective_data.title)

func load_grid_state(objective_data) -> void:
	if is_instance_valid(Globals.farm_grid):
		pass
	else :
		await Events.grid_loaded
	if not objective_data.grid_state.is_empty():
		for slot in objective_data.grid_state:
			var i = objective_data.grid_state[slot]
			Events.update_grid.emit(slot, [i.crop, i.growth, i.water])

func load_next_lvl() -> void:
	clear_list()
	ObjectiveManager.clear_data()
	objData = ObjectiveData.new()
	load_objectives(current_lvl + 1)

func load_prev_lvl() -> void:
	clear_list()
	ObjectiveManager.clear_data()
	objData = ObjectiveData.new()
	load_objectives(current_lvl - 1)

func _on_objective_completed():
	if objectives.all(func(element): return element.completed):
		print("Level completed")
		Events.level_completed.emit(current_lvl)

func show_popup(lv_text:String) -> void:
	var popup = lv_popup.instantiate()
	popup.lb_text = lv_text
	add_sibling.call_deferred(popup)

func reset_lvl() -> void:
	clear_list()
	ObjectiveManager.clear_data()
	objData = ObjectiveData.new()
	load_objectives(current_lvl)

func _on_quest_tip_btn_pressed():
	if not is_instance_valid(Globals.tip_panel):
		SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_01.wav")
		var tip_p = questTipPanel.instantiate()
		tip_p.tip_text = tip_text
		get_parent().add_child(tip_p)

func _on_tutorial_completed() -> void:
	var objective_data = objData.DATA[current_lvl]
	var lv_text = objective_data.title
	show_popup(lv_text)
