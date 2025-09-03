extends Node

@onready var start_position = $StartPosition.position
@onready var robot : RobotClass = $Robot
@onready var farm : FarmGrid = $FarmGrid
@export var translationScreen = preload("res://Scenes/UI/translation_panel.tscn")

func _ready():
	robot.position = start_position
	robot.rest_position = start_position
	robot.farm = farm
	set_mouse_cursors()
	

func set_mouse_cursors() -> void:
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/hand_open.png"), Input.CURSOR_POINTING_HAND, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/hand_closed.png"), Input.CURSOR_DRAG, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/ok.png"), Input.CURSOR_CAN_DROP, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/hand_closed.png"), Input.CURSOR_FORBIDDEN, Vector2(6, 6))

func _on_reset_btn_pressed():
	get_tree().reload_current_scene()

func _on_to_portugol_pressed():
	var new = translationScreen.instantiate()
	$UI.add_child(new)
	await get_tree().process_frame
	Events.to_portugol.emit($UI/CommandPanel.to_portugol())
