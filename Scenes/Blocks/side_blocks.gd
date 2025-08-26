extends Panel

@export var blockID : int = 0
@export var blockColor : Color
@onready var label = $Label
var blockInfo = BlockInfo.new()

func _ready():
	self_modulate = blockColor

func _get_drag_data(_at_position: Vector2):
	var drag_data = create_block_data(blockID)
	var preview = BlockPreview.new(label.text, blockColor)
	set_drag_preview(preview)
	return drag_data

func create_block_data(ID:int) -> BlockData:
	var block : BlockData
	if ID == blockInfo.PARA_FACA:
		block.loop(1)
	elif ID == blockInfo.SE_SENAO:
		block.if_else("is_empty")
	elif ID == blockInfo.ENQUANTO:
		block.while_do("is_empty")
	elif ID == blockInfo.FUNCAO:
		block.function()
	else:
		block.method(blockInfo.CODE_DATA[ID]["Name"])
	return block
