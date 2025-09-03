extends MarginContainer
class_name CodeContainer

const CODE_BLOCK = preload("res://Scenes/Blocks/code_block.tscn")
@onready var list = $List
signal code_list_updated(container:CodeContainer)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is BlockData:
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant):
	if data is BlockData:
		var new_block = CODE_BLOCK.instantiate()
		new_block.block_data = data
		list.add_child(new_block)
		$List/BottonMargin.move_to_front()
		code_list_updated.emit(self)

func get_code_blocks() -> Array:
	var blocks = $List.get_children()
	var block_data : Array[BlockData] = []
	var _margin = blocks.pop_back() #remove margin node
	for block in blocks:
		block_data.append(block.block_data)
	return block_data

func clear_code_blocks() -> void:
	for child in $List.get_children():
		if child is CodeBlock:
			child.queue_free()
