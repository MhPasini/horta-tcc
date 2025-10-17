extends Control
class_name CodeBlock

var parent_container : CodeContainer

@export var block_data : BlockData

@onready var methods = $MarginContainer/Methods
@onready var if_else = $MarginContainer/IfElse
@onready var while_loop = $MarginContainer/While
@onready var for_loop = $MarginContainer/ForLoop
@onready var x = $MarginContainer/Methods/Coords/X
@onready var y = $MarginContainer/Methods/Coords/Y
@onready var val_if = $MarginContainer/IfElse/args/val
@onready var val_while = $MarginContainer/While/args/val
@onready var val_loop = $MarginContainer/ForLoop/args/val

func _ready():
	_set_line_edit_filters()
	build_block()

func build_block() -> void:
	self_modulate = block_data.color
	match block_data.type:
		block_data.Type.METHOD:
			_build_method()
		block_data.Type.LOOP:
			_build_for_loop()
		block_data.Type.WHILE:
			_build_while()
		block_data.Type.IF:
			_build_if_else()
		block_data.Type.FUNCTION:
			_build_function()

func _build_method() -> void:
	methods.show()
	var method_name = block_data.name
	$MarginContainer/Methods/Name.text = block_data.block_text
	if method_name == "move_to":
		$MarginContainer/Methods/Coords.show()
	elif method_name == "plant_crop":
		%SeedSelection.show()
		%SeedSelection.select(block_data.plant_seed)
		%SeedSelection.item_selected.emit(block_data.plant_seed)
	elif method_name == "wait_for":
		%WaitTime.show()

func _build_for_loop() -> void:
	for_loop.show()
	val_loop.text = str(block_data.loop_count)
	var for_childs : CodeContainer = $MarginContainer/ForLoop/Childs
	for_childs.code_list_updated.connect(_on_child_list_updated)

func _build_while() -> void:
	while_loop.show()
	$MarginContainer/While/args/Condition.select(0)
	$MarginContainer/While/args/Condition2.select(0)
	$MarginContainer/While/args/Condition.item_selected.emit(0)
	var while_childs : CodeContainer = $MarginContainer/While/Childs
	while_childs.code_list_updated.connect(_on_child_list_updated)

func _build_if_else() -> void:
	if_else.show()
	$MarginContainer/IfElse/args/Condition.select(0)
	$MarginContainer/IfElse/args/Condition2.select(0)
	$MarginContainer/IfElse/args/Condition.item_selected.emit(0)
	var if_childs : CodeContainer = $MarginContainer/IfElse/IfChilds
	if_childs.code_list_updated.connect(_on_child_list_updated)
	var else_childs : CodeContainer = %ElseChilds
	else_childs.code_list_updated.connect(_on_else_list_updated)

func _build_function() -> void:
	methods.show()
	$MarginContainer/Methods/Name.text = block_data.name
	block_data.func_container.code_list_updated.connect(_on_child_list_updated)
	add_to_group(block_data.name)

func _on_else_btn_toggled(toggled_on):
	%ElseChilds.visible = toggled_on
	%ElseBtn.flip_v = toggled_on

func _set_line_edit_filters() -> void:
	val_if.text_changed.connect(_on_LineEdit_text_changed.bind(val_if))
	val_while.text_changed.connect(_on_LineEdit_text_changed.bind(val_while))
	val_loop.text_changed.connect(_on_LineEdit_text_changed.bind(val_loop))

func _on_LineEdit_text_changed(new_text: String, line_edit: LineEdit):
	if not new_text.is_valid_int():
		line_edit.text = str(new_text.to_int())
	if line_edit == val_loop:
		block_data.loop_count = new_text.to_int()
		return
	block_data.condition[1] = new_text.to_int()

func _on_if_condition_item_selected(index):
	var text = $MarginContainer/IfElse/args/Condition.get_item_text(index)
	$MarginContainer/IfElse/args/Condition2.visible = (index in [4, 5])
	$MarginContainer/IfElse/args/Condition3.visible = (index in [0, 1, 2])
	$MarginContainer/IfElse/args/equal.visible = (index in [0, 1, 2])
	val_if.visible = (index in [4, 5])
	if index in [4, 5]:
		var cond_aux = $MarginContainer/IfElse/args/Condition2.get_selected_id()
		block_data.condition[0] = _create_new_condition(text, cond_aux)
		val_if.text_changed.emit(str(0))
	else: 
		block_data.condition[0] = text
		block_data.condition_text = text

func _on_while_condition_item_selected(index):
	var text = $MarginContainer/While/args/Condition.get_item_text(index)
	$MarginContainer/While/args/Condition2.visible = (index in [4, 5])
	$MarginContainer/While/args/Condition3.visible = (index in [0, 1, 2])
	$MarginContainer/While/args/equal.visible = (index in [0, 1, 2])
	val_while.visible = (index in [4, 5])
	if index in [4, 5]:
		var cond_aux = $MarginContainer/While/args/Condition2.get_selected_id()
		block_data.condition[0] = _create_new_condition(text, cond_aux)
		val_while.text_changed.emit(str(0))
	else: 
		block_data.condition[0] = text
		block_data.condition_text = text

func _create_new_condition(text, aux) -> String:
	var new_condition = text
	match aux:
		0:
			new_condition += "_igual"
			block_data.block_text = text + " =="
			block_data.condition_text = text + " =="
		1:
			new_condition += "_maior_igual"
			block_data.block_text = text + " >="
			block_data.condition_text = text + " >="
		2:
			new_condition += "_menor_igual"
			block_data.block_text = text + " <="
			block_data.condition_text = text + " <="
		3:
			new_condition += "_maior"
			block_data.block_text = text + " >"
			block_data.condition_text = text + " >"
		4:
			new_condition += "_menor"
			block_data.block_text = text + " <"
			block_data.condition_text = text + " <"
		5:
			new_condition += "_diferente"
			block_data.block_text = text + " !="
			block_data.condition_text = text + " !="
	return new_condition

func _on_seed_selection_item_selected(index):
	block_data.plant_seed = index + 1
	block_data.seed_name = %SeedSelection.get_item_text(index)

func _on_if_condition_2_item_selected(index):
	var id = $MarginContainer/IfElse/args/Condition.get_selected_id()
	var text = $MarginContainer/IfElse/args/Condition.get_item_text(id)
	block_data.condition[0] = _create_new_condition(text, index)

func _on_if_condition_3_item_selected(index):
	var value = true if index == 0 else false
	block_data.condition[2] = value

func _on_while_condition_2_item_selected(index):
	var id = $MarginContainer/While/args/Condition.get_selected_id()
	var text = $MarginContainer/While/args/Condition.get_item_text(id)
	block_data.condition[0] = _create_new_condition(text, index)

func _on_while_condition_3_item_selected(index):
	var value = true if index == 0 else false
	block_data.condition[2] = value

func _on_child_list_updated(container:CodeContainer) -> void:
	block_data.child_blocks = container.get_code_blocks()

func _on_else_list_updated(container:CodeContainer) -> void:
	block_data.else_blocks = container.get_code_blocks()

func _on_x_text_changed(new_text:String):
	if not new_text.is_valid_int():
		x.text = str(new_text.to_int())
	block_data.pos.x = new_text.to_int()

func _on_y_text_changed(new_text:String):
	if not new_text.is_valid_int():
		y.text = str(new_text.to_int())
	block_data.pos.y = new_text.to_int()

func _on_wait_time_text_changed(new_text:String):
	if not new_text.is_valid_float():
		%WaitTime.text = str(new_text.to_float())
	block_data.wait_time = new_text.to_float()

func _get_drag_data(_at_position: Vector2):
	var preview = BlockPreview.new(block_data.block_text, block_data.color)
	set_drag_preview(preview)
	self.hide()
	return self

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		self.show()
