extends Resource
class_name CodeTranslator

static func to_portugol(program:Array[BlockData]) -> String:
	var code = "ALGORITMO\n"
	code += "INICIO\n"
	for block in program:
		code += _block_to_portugol(block, 1)
	code += "FIM\n"
	return code

static func to_python(program: Array[BlockData]) -> String:
	var code = "# Programa gerado automaticamente\n"
	code += "def main():\n"
	for block in program:
		code += _block_to_python(block, 1)
	code += "\nif __name__ == '__main__':\n"
	code += "    main()\n"
	return code

static func to_c(program: Array[BlockData]) -> String:
	var code = "#include <stdio.h>\n"
	code += "#include <stdlib.h>\n\n"
	code += "// Protótipos das funções\n"
	code += generate_function_prototypes(program)
	code += "\nint main() {\n"
	for block in program:
		code += _block_to_c(block, 1)
	code += "    return 0;\n"
	code += "}\n"
	return code

static func _block_to_portugol(block:BlockData, indent_level: int = 0) -> String:
	var indent = ""
	for i in range(indent_level):
		indent += "	"
	var code = ""
	match block.type:
		block.Type.METHOD:
			code += indent + block.block_text + _method_param(block) + "\n"
		block.Type.LOOP:
			code += indent + "PARA i DE 1 ATÉ " + str(block.loop_count) + " FAÇA\n"
			for child in block.child_blocks:
				code += _block_to_portugol(child, indent_level + 1)
			code += indent + "FIM PARA\n"
		block.Type.WHILE:
			code += indent + "ENQUANTO " + block.block_text + _check_cond_2(block) + " FAÇA\n"
			for child in block.child_blocks:
				code += _block_to_portugol(child, indent_level + 1)
			code += indent + "FIM ENQUANTO\n"
		block.Type.IF:
			code += indent + "SE " + block.block_text + _check_cond_2(block) + " ENTÃO\n"
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

static func _block_to_python(block: BlockData, indent_level: int = 0) -> String:
	var indent = ""
	for i in range(indent_level):
		indent += "    "  # Python usa 4 espaços por convenção
	var code = ""
	match block.type:
		block.Type.METHOD:
			code += indent + block.block_text + _method_param(block) + "\n"
		block.Type.LOOP:
			code += indent + "for i in range(" + str(block.loop_count) + "):\n"
			if block.child_blocks.size() == 0:
				code += indent + "    pass\n"
			else:
				for child in block.child_blocks:
					code += _block_to_python(child, indent_level + 1)
		block.Type.WHILE:
			code += indent + "while " + block.block_text + _check_cond_2(block) + ":\n"
			if block.child_blocks.size() == 0:
				code += indent + "    pass\n"
			else:
				for child in block.child_blocks:
					code += _block_to_python(child, indent_level + 1)
		block.Type.IF:
			code += indent + "if " + block.block_text + _check_cond_2(block) + ":\n"
			if block.child_blocks.size() == 0:
				code += indent + "    pass\n"
			else:
				for child in block.child_blocks:
					code += _block_to_python(child, indent_level + 1)
			if block.else_blocks.size() > 0:
				code += indent + "else:\n"
				for child in block.else_blocks:
					code += _block_to_python(child, indent_level + 1)
		block.Type.FUNCTION:
			code += indent + block.name + "()\n"
	return code

static func _block_to_c(block: BlockData, indent_level: int = 0) -> String:
	var indent = ""
	for i in range(indent_level):
		indent += "    "  # C também usa 4 espaços
	var code = ""
	match block.type:
		block.Type.METHOD:
			code += indent + block.block_text + _method_param(block) + ";\n"
		block.Type.LOOP:
			code += indent + "for (int i = 0; i < " + str(block.loop_count) + "; i++) {\n"
			for child in block.child_blocks:
				code += _block_to_c(child, indent_level + 1)
			code += indent + "}\n"
		block.Type.WHILE:
			code += indent + "while (" + block.block_text + _check_cond_2(block) + ") {\n"
			for child in block.child_blocks:
				code += _block_to_c(child, indent_level + 1)
			code += indent + "}\n"
		block.Type.IF:
			code += indent + "if (" + block.block_text + _check_cond_2(block) + ") {\n"
			for child in block.child_blocks:
				code += _block_to_c(child, indent_level + 1)
			if block.else_blocks.size() > 0:
				code += indent + "} else {\n"
				for child in block.else_blocks:
					code += _block_to_c(child, indent_level + 1)
			code += indent + "}\n"
		block.Type.FUNCTION:
			code += indent + block.name + "();\n"
	return code

static func generate_function_prototypes(program: Array[BlockData]) -> String:
	var prototypes = ""
	var functions_found = []
	extract_functions_recursive(program, functions_found)
	for func_name in functions_found:
		prototypes += "void " + func_name + "();\n"
		#TODO set params in CodeInfo and get it here
	return prototypes

static func extract_functions_recursive(blocks: Array[BlockData], functions_found: Array):
	for block in blocks:
		if block.type == block.Type.METHOD or block.type == block.Type.FUNCTION:
			if block.block_text not in functions_found:
				functions_found.append(block.block_text)
		if block.child_blocks.size() > 0:
			extract_functions_recursive(block.child_blocks, functions_found)
		if block.else_blocks.size() > 0:
			extract_functions_recursive(block.else_blocks, functions_found)

static func _check_cond_2(block:BlockData) -> String:
	var cond2 = " " + str(block.condition[1]) if block.condition[1] != null else ""
	return cond2

static func _method_param(block:BlockData) -> String:
	if block.name == "move_to":
		return "%s" % str(block.pos)
	elif block.name == "plant_crop":
		return "('%s')" % block.seed_name
	return "()"
