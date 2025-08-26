extends Resource
class_name BlockData

enum Type {
	METHOD,
	LOOP,
	WHILE,
	IF,
	FUNCTION
}

@export var type : Type = Type.METHOD
@export var name : String = ""
@export var condition : String = ""
@export var loop_count : int = 1
@export var child_blocks : Array[BlockData] = []
@export var else_blocks : Array[BlockData] = []
@export var color : Color = Globals.method_color

static func method(method_name:String) -> BlockData:
	var block = BlockData.new()
	block.type = Type.METHOD
	block.name = method_name
	block.color = Globals.method_color
	return block

static func loop(count:int, blocks:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.LOOP
	block.loop_count = count
	block.child_blocks = blocks
	block.color = Globals.loop_color
	return block

static func while_do(condition_name:String, blocks:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.WHILE
	block.condition = condition_name
	block.child_blocks = blocks
	block.color = Globals.while_color
	return block

static func if_else(condition_name:String, if_blocks:Array[BlockData] = [], else_b:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.IF
	block.condition = condition_name
	block.child_blocks = if_blocks
	block.else_blocks = else_b
	block.color = Globals.if_color
	return block

static func function(blocks:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.FUNCTION
	block.child_blocks = blocks
	block.color = Globals.function_color
	return block
