extends Button
class_name LvBtn

@onready var check = $Check
@export var check_icons : Array[CompressedTexture2D]
var lvl_text : String : set = _on_lvl_text_set
var info_text : String = ""
var id : int = 0

func _ready():
	if id == Globals.level_selected:
		set_pressed_no_signal(true)

func set_completed(v:bool) -> void:
	if v:
		check.texture = check_icons[1]
	else:
		check.texture = check_icons[0]

func _on_lvl_text_set(v:String) -> void:
	lvl_text = v
	text = v
