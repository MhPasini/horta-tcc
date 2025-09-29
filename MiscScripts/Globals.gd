extends Node

const MSG_TYPE = {
	"normal": "",
	"warning": "[color=yellow]AVISO: [/color]",
	"error": "[color=red]ERRO: [/color]"
}

const carrot_sprite : Texture = preload("res://Textures/crops/carrot.png")
const onion_sprite : Texture = preload("res://Textures/crops/onion.png")
const radish_sprite : Texture = preload("res://Textures/crops/radish.png")
const potato_sprite : Texture = preload("res://Textures/crops/potato.png")
const turnip_sprite : Texture = preload("res://Textures/crops/turnip.png")

#Colors
const block_font_color = Color("575757")
#const method_color = Color("9ec9d9")
#const loop_color = Color("9ec9d9")
#const while_color = Color("9ec9d9")
#const if_color = Color("9ec9d9")
#const function_color = Color("9ec9d9")

var robot_ref : RobotClass
var active_code_tab : int = 0
var cmd_panel
var tip_panel = null
var func_list = []
var levels_completed : Array[bool]

func _ready():
	set_mouse_cursors()
	var objData = ObjectiveData.new()
	levels_completed.resize(objData.DATA.size())
	print(levels_completed)

func set_mouse_cursors() -> void:
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/hand_open.png"), Input.CURSOR_POINTING_HAND, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/hand_closed.png"), Input.CURSOR_DRAG, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/ok.png"), Input.CURSOR_CAN_DROP, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/hand_closed.png"), Input.CURSOR_FORBIDDEN, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/move_window.png"), Input.CURSOR_MOVE, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/size_h.png"), Input.CURSOR_HSIZE, Vector2(6, 6))
	Input.set_custom_mouse_cursor(load("res://UI/Cursors/size_v.png"), Input.CURSOR_VSIZE, Vector2(6, 6))
