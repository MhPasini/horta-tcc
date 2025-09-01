extends MarginContainer
class_name CodeContainer

const CODE_BLOCK = preload("res://Scenes/Blocks/code_block.tscn")
@onready var list = $List

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

func get_code_blocks() -> Array:
	var blocks = $VBoxContainer.get_children()
	return blocks
