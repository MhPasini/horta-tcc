extends Control

var robot : RobotClass
var is_playing : bool = false
var program : Array[BlockData] = []

@onready var code_container = $CodePanel/CodeTabs/Main/CodeContainer as CodeContainer
@onready var info_text = $InfoPanel/Info


func _ready():
	robot = Globals.robot_ref
	Events.update_info_text.connect(_update_info_text)

func run_program() -> void:
	for block in program:
		_execute(block)

func _execute(block:BlockData) -> void:
	match block.type:
		block.Type.METHOD:
			var _ok = await robot.call(block.name)
			if not _ok:
				print("Stop code execution.")
				return
		block.Type.LOOP:
			for i in range(block.loop_count):
				for child in block.child_blocks:
					_execute(child)
		block.Type.WHILE:
			var max_iterations = 1000
			var iterations = 0
			while _check_condition(block.condition) and iterations < max_iterations:
				for child in block.child_blocks:
					_execute(child)
					iterations += 1
			if iterations >= max_iterations:
				print("Execução do código interrompida, loop >= ", max_iterations)
		block.Type.IF:
			if _check_condition(block.condition):
				for child in block.child_blocks:
					_execute(child)
			else:
				for child in block.else_blocks:
					_execute(child)
		block.Type.FUNCTION:
			for child in block.child_blocks:
				_execute(child)

func update_program() -> void:
	program = code_container.get_code_blocks()

func _check_condition(condition:Array) -> bool:
	if robot and robot.has_method(condition[0]):
		return robot.call(condition[0], condition[1])
	else:
		print("Condição não encontrada: ", condition)
		return false

#region TRADUÇÃO DE BLOCOS
func to_portugol() -> String:
	var code = "ALGORITMO\n"
	code += "INICIO\n"
	for block in program:
		code += _block_to_portugol(block, 1)
	code += "FIM\n"
	return code

func _block_to_portugol(block:BlockData, indent_level: int = 0) -> String:
	var indent = ""
	for i in range(indent_level):
		indent += "	"
	var code = ""
	match block.type:
		block.Type.METHOD:
			code += indent + block.name + "()\n"
		block.Type.LOOP:
			code += indent + "PARA i DE 1 ATÉ " + str(block.loop_count) + " FAÇA\n"
			for child in block.child_blocks:
				code += _block_to_portugol(child, indent_level + 1)
			code += indent + "FIM PARA\n"
		block.Type.WHILE:
			code += indent + "ENQUANTO " + block.condition + "() FAÇA\n"
			for child in block.child_blocks:
				code += _block_to_portugol(child, indent_level + 1)
			code += indent + "FIM ENQUANTO\n"
		block.Type.IF:
			code += indent + "SE " + block.condition + "() ENTÃO\n"
			for child in block.child_blocks:
				code += _block_to_portugol(child, indent_level + 1)
			if block.else_blocks.size() > 0:
				code += indent + "SENÃO\n"
				for child in block.else_blocks:
					code += _block_to_portugol(child, indent_level + 1)
			code += indent + "FIM SE\n"
		block.Type.FUNCTION:
			code += indent + block.name + "()\n"
	return code
#endregion

func _update_info_text(new_info:String) -> void:
	info_text.text = new_info

func _on_play_pressed() -> void:
	pass # Replace with function body.

func _on_pause_pressed() -> void:
	pass # Replace with function body.
