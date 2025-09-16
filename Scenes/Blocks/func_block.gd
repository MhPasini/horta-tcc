extends Panel

var data = BlockData
@onready var label = $Label

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	Events.code_tab_changed.connect(_on_tab_changed)
	set_label(data.name)

func _get_drag_data(_at_position: Vector2):
	var preview = BlockPreview.new(data.block_text, self_modulate)
	set_drag_preview(preview)
	return data

func _on_mouse_entered() -> void:
	Events.update_info_text.emit(BlockInfo.CODE_DATA[10]["Info"])

func set_label(new:String) -> void:
	label.text = new

func _on_tab_changed(tab:int) -> void:
	visible = !tab
