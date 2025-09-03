extends Control
class_name CodeBlock

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
	$Panel.modulate = block_data.color
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
		$MarginContainer/Methods/SeedSelection.show()
		$MarginContainer/Methods/SeedSelection.select(0)
		block_data.plant_seed = 1

func _build_for_loop() -> void:
	for_loop.show()
	var for_childs : CodeContainer = $MarginContainer/ForLoop/Childs
	for_childs.code_list_updated.connect(_on_child_list_updated)

func _build_while() -> void:
	while_loop.show()
	$MarginContainer/While/args/Condition.select(0)
	$MarginContainer/While/args/Condition2.select(0)
	block_data.condition[0] = "lote_vazio"
	var while_childs : CodeContainer = $MarginContainer/While/Childs
	while_childs.code_list_updated.connect(_on_child_list_updated)

func _build_if_else() -> void:
	if_else.show()
	%ElseBtn.button_pressed = true
	$MarginContainer/IfElse/args/Condition.select(0)
	$MarginContainer/IfElse/args/Condition2.select(0)
	block_data.condition[0] = "lote_vazio"
	var if_childs : CodeContainer = $MarginContainer/IfElse/IfChilds
	if_childs.code_list_updated.connect(_on_child_list_updated)
	var else_childs : CodeContainer = %ElseChilds
	else_childs.code_list_updated.connect(_on_else_list_updated)

func _build_function() -> void:
	methods.show()
	$MarginContainer/Methods/Name.text = block_data.name

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
	if line_edit == $MarginContainer/ForLoop/args/val:
		block_data.loop_count = new_text.to_int()
		return
	block_data.condition[1] = new_text.to_int()

func _on_if_condition_item_selected(index):
	var text = $MarginContainer/IfElse/args/Condition.get_item_text(index)
	$MarginContainer/IfElse/args/Condition2.visible = (index in [4, 5])
	$MarginContainer/IfElse/args/val.visible = (index in [4, 5])
	if index in [4, 5]:
		var cond_aux = $MarginContainer/While/args/Condition2.get_selected_id()
		block_data.condition[0] = _create_new_condition(text, cond_aux)
	else: 
		block_data.condition[0] = text
	
	print(block_data.condition[0])
	

func _on_while_condition_item_selected(index):
	var text = $MarginContainer/While/args/Condition.get_item_text(index)
	$MarginContainer/While/args/Condition2.visible = (index in [4, 5])
	$MarginContainer/While/args/val.visible = (index in [4, 5])
	if index in [4, 5]:
		var cond_aux = $MarginContainer/While/args/Condition2.get_selected_id()
		block_data.condition[0] = _create_new_condition(text, cond_aux)
	else: 
		block_data.condition[0] = text
	
	print(block_data.condition[0])
	

func _create_new_condition(text, aux) -> String:
	var new_condition = text
	match aux:
		0:
			new_condition += "_igual"
		1:
			new_condition += "_maior_igual"
		2:
			new_condition += "_menor_igual"
		3:
			new_condition += "_maior"
		4:
			new_condition += "_menor"
		5:
			new_condition += "_diferente"
	return new_condition

func _on_seed_selection_item_selected(index):
	block_data.plant_seed = index + 1

func _on_if_condition_2_item_selected(index):
	var id = $MarginContainer/IfElse/args/Condition.get_selected_id()
	var text = $MarginContainer/IfElse/args/Condition.get_item_text(id)
	block_data.condition[0] = _create_new_condition(text, index)
	print(block_data.condition[0])

func _on_while_condition_2_item_selected(index):
	var id = $MarginContainer/While/args/Condition.get_selected_id()
	var text = $MarginContainer/While/args/Condition.get_item_text(id)
	block_data.condition[0] = _create_new_condition(text, index)
	print(block_data.condition[0])

func _on_child_list_updated(container:CodeContainer) -> void:
	block_data.child_blocks = container.get_code_blocks()

func _on_else_list_updated(container:CodeContainer) -> void:
	block_data.else_blocks = container.get_code_blocks()

func _on_x_text_changed(new_text):
	if not new_text.is_valid_int():
		x.text = str(new_text.to_int())
	block_data.pos.x = new_text.to_int()

func _on_y_text_changed(new_text):
	if not new_text.is_valid_int():
		y.text = str(new_text.to_int())
	block_data.pos.y = new_text.to_int()
