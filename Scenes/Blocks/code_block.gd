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
	%ElseBtn.button_pressed = true
	_set_line_edit_filters()
	build_block()

func build_block() -> void:
	$Panel.modulate = block_data.color
	match block_data.type:
		block_data.Type.METHOD:
			_build_method()
		block_data.Type.LOOP:
			_build_loop()
		block_data.Type.WHILE:
			_build_while()
		block_data.Type.IF:
			_build_if_else()
		block_data.Type.FUNCTION:
			_build_function()

func _build_method() -> void:
	methods.show()
	var method_name = block_data.name
	$MarginContainer/Methods/Name.text = method_name
	if method_name == "move_to":
		$MarginContainer/Methods/Coords.show()
	elif method_name == "plant_crop":
		$MarginContainer/Methods/SeedSelection.show()

func _build_loop() -> void:
	pass

func _build_while() -> void:
	pass

func _build_if_else() -> void:
	pass

func _build_function() -> void:
	pass

func _on_else_btn_toggled(toggled_on):
	%ElseChilds.visible = toggled_on
	%ElseBtn.flip_v = toggled_on

func _set_line_edit_filters() -> void:
	x.text_changed.connect(_on_LineEdit_text_changed.bind(x))
	y.text_changed.connect(_on_LineEdit_text_changed.bind(y))
	val_if.text_changed.connect(_on_LineEdit_text_changed.bind(val_if))
	val_while.text_changed.connect(_on_LineEdit_text_changed.bind(val_while))
	val_loop.text_changed.connect(_on_LineEdit_text_changed.bind(val_loop))

func _on_LineEdit_text_changed(new_text: String, line_edit: LineEdit):
	if not new_text.is_valid_int():
		line_edit.text = str(new_text.to_int())
