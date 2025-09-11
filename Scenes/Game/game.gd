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
	Events.request_translation.connect(_on_translation_requested)
	set_mouse_cursors()

func set_mouse_cursors() -> void:
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/hand_open.png"), Input.CURSOR_POINTING_HAND, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/hand_closed.png"), Input.CURSOR_DRAG, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/ok.png"), Input.CURSOR_CAN_DROP, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/hand_closed.png"), Input.CURSOR_FORBIDDEN, Vector2(6, 6))

func _on_reset_btn_pressed():
	get_tree().reload_current_scene()

func _on_translation_btn_pressed():
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
