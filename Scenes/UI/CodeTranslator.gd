extends Resource
class_name CodeTranslator

#colors
const pnk = "#d47896"
const red = "#b8545e"
const pur = "#b685d1"
const cya = "#8bcdca"
const ylw = "#decc73"

static func to_portugol(program:Array[BlockData]) -> String:
	var code = _c("ALGORITMO\n\n", red)
	code += _c("INICIO\n", red)
	for block in program:
		code += _block_to_portugol(block, 1)
	code += _c("FIM\n", red)
	return code

static func to_python(program: Array[BlockData]) -> String:
	var code = "# Tradução para Python\n"
	code += _c("def ", red) + _c("main", cya) + "():\n"
	for block in program:
		code += _block_to_python(block, 1)
	code += "\n" + _c("if", pnk) +" __name__ == '__main__':\n"
	code += "    " + _c("main", cya) + "()\n"
	return code

static func to_c(program: Array[BlockData]) -> String:
	var code = "#include <stdio.h>\n"
	code += "#include <stdlib.h>\n\n"
	code += "// Tradução para C\n"
	#code += generate_function_prototypes(program)
	code += _c("void", red) + _c(" main", cya) +"() {\n"
	for block in program:
		code += _block_to_c(block, 1)
	code += ".   " + _c("return", pnk) + ";\n"
	code += "}\n"
	return code

static func _block_to_portugol(block:BlockData, indent_level: int = 0) -> String:
	var indent = ""
	for i in range(indent_level):
		indent += ".   "
	var code = ""
	match block.type:
		block.Type.METHOD:
			code += indent + _c(block.block_text, cya) + _method_param(block) + "\n"
		block.Type.LOOP:
			code += (
				indent + _c("PARA", pnk) + " i DE 1 ATÉ " + 
				str(block.loop_count) + _c(" FAÇA\n", pnk)
				)
			for child in block.child_blocks:
				code += _block_to_portugol(child, indent_level + 1)
			code += indent + _c("FIM PARA\n", pnk)
		block.Type.WHILE:
			code += (
				indent + _c("ENQUANTO ", pnk) + 
				block.condition_text + _c_con(block) + 
				_c(" FAÇA\n", pnk)
				)
			for child in block.child_blocks:
				code += _block_to_portugol(child, indent_level + 1)
			code += indent + _c("FIM ENQUANTO\n", pnk)
		block.Type.IF:
			code += (
				indent + _c("SE ", pnk) + 
				block.condition_text + _c_con(block) + 
				_c(" ENTÃO\n", pnk)
				)
			for child in block.child_blocks:
				code += _block_to_portugol(child, indent_level + 1)
			if block.else_blocks.size() > 0:
				code += indent + _c("SENÃO\n", pnk)
				for child in block.else_blocks:
					code += _block_to_portugol(child, indent_level + 1)
			code += indent + _c("FIM SE\n", pnk)
		block.Type.FUNCTION:
			code += indent + block.name + "()\n"
	return code

static func _block_to_python(block: BlockData, indent_level: int = 0) -> String:
	var indent = ""
	for i in range(indent_level):
		indent += "    " # 4 espaço
	var code = ""
	match block.type:
		block.Type.METHOD:
			code += indent + _c(block.block_text, cya) + _method_param(block) + "\n"
		block.Type.LOOP:
			code += (
				indent + _c("for",pnk) + " i " +
				_c("in ",red) + _c("range",pur) +
				"(" + str(block.loop_count) + "):\n"
				)
			if block.child_blocks.size() == 0:
				code += indent + _c("    pass\n", red)
			else:
				for child in block.child_blocks:
					code += _block_to_python(child, indent_level + 1)
		block.Type.WHILE:
			code += indent + _c("while ",pnk) + block.condition_text + _c_con(block) + ":\n"
			if block.child_blocks.size() == 0:
				code += indent + _c("    pass\n", red)
			else:
				for child in block.child_blocks:
					code += _block_to_python(child, indent_level + 1)
		block.Type.IF:
			code += indent + _c("if ",pnk) + block.condition_text + _c_con(block) + ":\n"
			if block.child_blocks.size() == 0:
				code += indent + _c("    pass\n", red)
			else:
				for child in block.child_blocks:
					code += _block_to_python(child, indent_level + 1)
			if block.else_blocks.size() > 0:
				code += indent + _c("else:\n", pnk)
				for child in block.else_blocks:
					code += _block_to_python(child, indent_level + 1)
		block.Type.FUNCTION:
			code += indent + block.name + "()\n"
	return code

static func _block_to_c(block: BlockData, indent_level: int = 0) -> String:
	var indent = ""
	for i in range(indent_level):
		indent += ".   "  # 4 espaços
	var code = ""
	match block.type:
		block.Type.METHOD:
			code += indent + _c(block.block_text, cya) + _method_param(block) + ";\n"
		block.Type.LOOP:
			code += (
				indent + _c("for", pnk) + " (int i = 0; i < " +
				str(block.loop_count) + "; i++) {\n"
				)
			for child in block.child_blocks:
				code += _block_to_c(child, indent_level + 1)
			code += indent + "}\n"
		block.Type.WHILE:
			code += (
				indent + _c("while ", pnk) + "(" +
				block.condition_text + _c_con(block) + ") {\n"
				)
			for child in block.child_blocks:
				code += _block_to_c(child, indent_level + 1)
			code += indent + "}\n"
		block.Type.IF:
			code += (
				indent + _c("if ", pnk) + "(" + 
				block.condition_text + _c_con(block) + ") {\n"
				)
			for child in block.child_blocks:
				code += _block_to_c(child, indent_level + 1)
			if block.else_blocks.size() > 0:
				code += indent + "}" + _c("else ", pnk) + "{\n"
				for child in block.else_blocks:
					code += _block_to_c(child, indent_level + 1)
			code += indent + "}\n"
		block.Type.FUNCTION:
			code += indent + block.name + "();\n"
	return code
#
#static func generate_function_prototypes(program: Array[BlockData]) -> String:
	#var prototypes = ""
	#var functions_found = []
	#extract_functions_recursive(program, functions_found)
	#for func_name in functions_found:
		#prototypes += "void " + func_name + "(" + _get_param_type() + ");\n"
	#return prototypes
#
#static func extract_functions_recursive(blocks: Array[BlockData], functions_found: Array):
	#for block in blocks:
		#if block.type == block.Type.METHOD or block.type == block.Type.FUNCTION:
			#if block.block_text not in functions_found:
				#functions_found.append(block.block_text)
		#if block.child_blocks.size() > 0:
			#extract_functions_recursive(block.child_blocks, functions_found)
		#if block.else_blocks.size() > 0:
			#extract_functions_recursive(block.else_blocks, functions_found)

static func _c_con(block:BlockData) -> String:
	var cond2 = " " + str(block.condition[1]) if block.condition[1] != null else ""
	return cond2

static func _method_param(block:BlockData) -> String:
	if block.name == "move_to":
		return "%s" % str(block.pos)
	elif block.name == "plant_crop":
		return "("+_c('"%s"'%block.seed_name,ylw)+")"
	return "()"

static func _get_param_type(type:int) -> String:
	return BlockInfo.CODE_DATA[type]["Param"] as String

static func _c(v:String, color:String) -> String:
	return "[color=" + color + "]" + v + "[/color]"
