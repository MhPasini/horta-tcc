extends Node

@onready var start_position = $StartPosition.position
@onready var robot : RobotClass = $Robot
@onready var farm : FarmGrid = $FarmGrid
@export var translationScreen = preload("res://Scenes/UI/translation_window.tscn")

const OPTIONS = preload("res://Scenes/UI/options.tscn")
const COMPLETED_POPUP = preload("res://Scenes/UI/lvl_completed.tscn")

var active_translation : Object = null

func _ready():
	robot.position = start_position
	robot.rest_position = start_position
	robot.farm = farm
	check_level_range()
	Events.request_translation.connect(_on_translation_requested)
	Events.level_completed.connect(_on_level_completed)

func _on_reset_btn_pressed() -> void:
	robot.reset_vars()
	farm.reset_grid()
	$UI/ObjectivesPanel.reset_lvl()
	if is_instance_valid(active_translation):
		active_translation.queue_free()

func _on_next_btn_pressed() -> void:
	robot.reset_vars()
	farm.reset_grid()
	$UI/ObjectivesPanel.load_next_lvl()
	check_level_range()

func _on_prev_btn_pressed():
	robot.reset_vars()
	farm.reset_grid()
	$UI/ObjectivesPanel.load_prev_lvl()
	check_level_range()

func _on_level_completed(ID:int) -> void:
	Globals.levels_completed[ID] = true
	DataManager.save_data()
	var node = COMPLETED_POPUP.instantiate()
	$UI.add_child(node)

func _on_translation_btn_pressed() -> void:
	Globals.cmd_panel.update_program()
	Events.request_translation.emit("portugol")

func _on_translation_requested(to:String = "portugol") -> void:
	if  not is_instance_valid(active_translation):
		var new_screen = translationScreen.instantiate()
		$UI.add_child(new_screen)
		active_translation = new_screen
		new_screen.tree_exiting.connect(_on_screen_deletion)
		await get_tree().process_frame
	else:
		active_translation.reset_position()
	var new_t : String
	match to.to_lower():
		"python":
			print("Tradução para Python...")
			new_t = CodeTranslator.to_python($UI/CommandPanel.program)
		"c":
			print("Tradução para C...")
			new_t = CodeTranslator.to_c($UI/CommandPanel.program)
		_:
			print("Tradução para Portugol...")
			new_t = CodeTranslator.to_portugol($UI/CommandPanel.program)
	Events.new_translation.emit(new_t)

func _on_screen_deletion() -> void:
	active_translation = null

func _on_options_btn_pressed():
	var node = OPTIONS.instantiate()
	$UI.add_child(node)

func check_level_range() -> void:
	if Globals.level_selected == 0:
		$UI/CommandPanel/LvlControl/PrevBtn.hide()
	else:
		$UI/CommandPanel/LvlControl/PrevBtn.show()
	if Globals.level_selected >= (Globals.levels_completed.size() - 1):
		$UI/CommandPanel/LvlControl/NextBtn.hide()
	else:
		$UI/CommandPanel/LvlControl/NextBtn.show()
