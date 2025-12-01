extends Panel

@export var blockID : int = 0
@export var blockColor : Color
@onready var label = $Label
var blockInfo = BlockInfo.new()

func _ready():
	self_modulate = blockColor
	mouse_entered.connect(_on_mouse_entered)

func _get_drag_data(_at_position: Vector2):
	var drag_data = create_block_data(blockID)
	var preview = BlockPreview.new(label.text, blockColor)
	drag_data.color = blockColor
	set_drag_preview(preview)
	SoundManager.play_sfx("res://Sounds&Music/whoosh_swish_small_12.wav", 1.5)
	return drag_data

func create_block_data(ID:int) -> BlockData:
	var block : BlockData
	if ID == blockInfo.PARA_FACA:
		block = BlockData.loop(1)
	elif ID == blockInfo.SE_SENAO:
		block = BlockData.if_else("is_empty")
	elif ID == blockInfo.ENQUANTO:
		block = BlockData.while_do("is_empty")
	elif ID == blockInfo.FUNCAO:
		block = BlockData.function()
	else:
		block = BlockData.method(blockInfo.CODE_DATA[ID]["Name"],
		blockInfo.CODE_DATA[ID]["BlockText"])
	return block

func _on_mouse_entered() -> void:
	Events.update_info_text.emit(blockInfo.CODE_DATA[blockID]["Info"])
