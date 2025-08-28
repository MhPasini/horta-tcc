extends MarginContainer
class_name CodeContainer

@onready var list = $List


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is BlockData:
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant):
	if data is BlockData:
		var new_block = CodeBlock.new()
		list.add_child(new_block)
		#new_block.build_block()
		print(data.name + " adicionado ao código")

func get_code_blocks() -> Array:
	var blocks = $VBoxContainer.get_children()
	return blocks
