extends Control

var robot : RobotClass
var program : Array[BlockData] = []

@onready var code_container = $CodePanel/CodeTabs/Main/CodeContainer as CodeContainer
@onready var info_text = $InfoPanel/Info

func _ready():
	robot = Globals.robot_ref
	Events.update_info_text.connect(_update_info_text)
	code_container.code_list_updated.connect(_on_code_list_updated)

func run_program() -> void:
	var _ok : bool = true
	robot.send_log_message("[color=green]*Início do programa*[/color]")
	for block in program:
		_ok = await _execute(block)
		if not _ok:
			break
		await create_tween().tween_interval(.25).finished
	if _ok:
		robot.send_log_message("[color=green]*Fim do programa*[/color]")
	else :
		robot.send_log_message("[color=red]*Execução terminada*[/color]")

func _execute(block:BlockData) -> bool:
	var _ok : bool = true
	match block.type:
		block.Type.METHOD:
			if block.name == "move_to":
				_ok = await robot.call(block.name, block.pos)
			elif block.name == "plant_crop":
				_ok = await robot.call(block.name, block.plant_seed)
			else :
				_ok = await robot.call(block.name)
			print("Cmd %s: " % block.name, _ok)
		block.Type.LOOP:
			for i in range(block.loop_count):
				for child in block.child_blocks:
					_ok = await _execute(child)
		block.Type.WHILE:
			var max_iterations = 100
			var iterations = 0
			while _check_condition(block.condition) and iterations < max_iterations:
				for child in block.child_blocks:
					_ok = await _execute(child)
					iterations += 1
			if iterations >= max_iterations:
				print("Execução do código interrompida, loop >= ", max_iterations)
				return false
		block.Type.IF:
			if _check_condition(block.condition):
				for child in block.child_blocks:
					_ok = await _execute(child)
			else:
				for child in block.else_blocks:
					_ok = await _execute(child)
		block.Type.FUNCTION:
			for child in block.child_blocks:
				_ok = await _execute(child)
	return _ok

func _on_code_list_updated(_code_container) -> void:
	update_program()

func update_program() -> void:
	program = code_container.get_code_blocks()

func clear_program() -> void:
	program.clear()
	code_container.clear_code_blocks()

func _check_condition(condition:Array) -> bool:
	print(condition)
	if robot and robot.has_method(condition[0]):
		if condition[1] != null:
			return robot.call(condition[0], condition[1])
		else :
			return robot.call(condition[0])
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
	update_program()
	run_program()

func _on_clear_pressed():
	clear_program()
