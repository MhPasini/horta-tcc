extends Node

@onready var start_position = $StartPosition.position
@onready var robot : RobotClass = $Robot
@onready var farm : FarmGrid = $FarmGrid
@export var translationScreen = preload("res://Scenes/UI/translation_window.tscn")

var active_translation : Object = null

func _ready():
	robot.position = start_position
	robot.rest_position = start_position
	robot.farm = farm
	#robot.send_stat_update()
	Events.request_translation.connect(_on_translation_requested)
	Events.level_completed.connect(_on_level_completed)

func _on_reset_btn_pressed() -> void:
	robot.reset_vars()
	$UI/ObjectivesPanel.reset_lvl()
	if is_instance_valid(active_translation):
		active_translation.queue_free()

func _on_next_btn_pressed() -> void:
	robot.reset_vars()
	$UI/ObjectivesPanel.load_next_lvl()

func _on_level_completed(ID:int) -> void:
	Globals.levels_completed[ID] = true
	$UI/CommandPanel/LvlControl/NextBtn.show()
	if ID == Globals.levels_completed.size():
		$UI/CommandPanel/LvlControl/NextBtn.disabled = true

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
