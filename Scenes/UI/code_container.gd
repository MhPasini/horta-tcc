extends MarginContainer
class_name CodeContainer

const CODE_BLOCK = preload("res://Scenes/Blocks/code_block.tscn")
const DROP_INDICATOR = preload("res://Scenes/Blocks/drop_indicator.tscn")
var drop_indicator
var func_container = false
var deleting = false

@onready var list = $List
signal code_list_updated(container:CodeContainer)

func _ready():
	drop_indicator = DROP_INDICATOR.instantiate()
	list.add_child(drop_indicator)
	list.child_order_changed.connect(_on_list_changed)
	drop_indicator.hide()

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is BlockData or data is CodeBlock:
		show_drop_indicator(_at_position)
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant):
	var drop_index = _get_drop_index(_at_position)
	var block_node : CodeBlock
	if data is BlockData:
		block_node = CODE_BLOCK.instantiate()
		block_node.block_data = data
		block_node.parent_container = self
		list.add_child(block_node)
	elif data is CodeBlock:
		block_node = data
		block_node.reparent(self.list)
		block_node.parent_container.emit_update_signal()
		block_node.parent_container = self
	self.list.move_child(block_node, drop_index)
	emit_update_signal()

func _get_drop_index(drop_position:Vector2) -> int:
	var children = list.get_children()
	children.erase(drop_indicator)
	if children.size() == 0:
		return 0
	for i in range(children.size()):
		var child = children[i]
		if not child.visible:
			continue
		var child_center = child.position.y + child.size.y/2
		if drop_position.y < child_center:
			return i
	return children.size()

func get_code_blocks() -> Array:
	var blocks = $List.get_children()
	var block_data : Array[BlockData] = []
	blocks.erase(drop_indicator)
	for block in blocks:
		block_data.append(block.block_data)
	return block_data

func remove_func_group() -> void:
	var group_name = get_parent().get_groups().pop_back()
	get_tree().call_group(group_name, "queue_free")
	var index = Globals.func_list.find(group_name)
	if index != -1:
		Globals.func_list.remove_at(index)

func show_drop_indicator(drop_position: Vector2) -> void:
	var drop_index = _get_drop_index(drop_position)
	drop_indicator.visible = true
	list.move_child(drop_indicator, drop_index)

func add_code_block(block:CodeBlock) -> void:
	block.reparent(self.list)
	block.parent_container.emit_update_signal()
	block.parent_container = self
	emit_update_signal()

func create_code_block(data:BlockData, at_index:int = 0) -> void:
	var block_node = CODE_BLOCK.instantiate()
	block_node.block_data = data
	block_node.parent_container = self
	list.add_child(block_node)
	list.move_child(block_node, at_index)
	emit_update_signal()

func remove_code_block(block:CodeBlock) -> void:
	block.queue_free()
	await get_tree().process_frame
	emit_update_signal()

func clear_code_blocks() -> void:
	for child in $List.get_children():
		if child is CodeBlock:
			child.queue_free()

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		drop_indicator.hide()
	elif what == NOTIFICATION_MOUSE_EXIT and get_viewport().gui_is_dragging():
		drop_indicator.hide()

func emit_update_signal() -> void:
	code_list_updated.emit(self)

func _on_list_changed() -> void:
	if list.get_child_count() <= 1 and func_container and not deleting:
		print("Container deleted: ", self.name)
		deleting = true
		remove_func_group()
