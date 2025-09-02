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
@export var condition : Array = ["", null]
@export var loop_count : int = 1
@export var child_blocks : Array[BlockData] = []
@export var else_blocks : Array[BlockData] = []
@export var plant_seed : int = 0
@export var pos : Vector2i = Vector2i.ZERO
@export var color : Color = Color("9ec9d9")
@export var block_text : String = ""

static func method(method_name:String, text:String) -> BlockData:
	var block = BlockData.new()
	block.type = Type.METHOD
	block.name = method_name
	block.block_text = text
	return block

static func loop(count:int, blocks:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.LOOP
	block.loop_count = count
	block.child_blocks = blocks
	return block

static func while_do(condition_name:String, blocks:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.WHILE
	block.condition[0] = condition_name
	block.child_blocks = blocks
	return block

static func if_else(condition_name:String, if_blocks:Array[BlockData] = [], else_b:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.IF
	block.condition[0] = condition_name
	block.child_blocks = if_blocks
	block.else_blocks = else_b
	return block

static func function(blocks:Array[BlockData] = [], func_name:String = "Função 1") -> BlockData:
	var block = BlockData.new()
	block.name = func_name
	block.type = Type.FUNCTION
	block.child_blocks = blocks
	return block
