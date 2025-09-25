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
@export var condition_text : String = ""
@export var wait_time : float = 1.0
@export var loop_count : int = 1
@export var child_blocks : Array[BlockData] = []
@export var else_blocks : Array[BlockData] = []
@export var plant_seed : int = 0
@export var seed_name : String = "Cenoura"
@export var pos : Vector2i = Vector2i.ZERO
@export var color : Color = Color("9ec9d9")
@export var block_text : String = ""
var func_container : CodeContainer

static func method(method_name:String, text:String) -> BlockData:
	var block = BlockData.new()
	block.type = Type.METHOD
	block.name = method_name
	block.block_text = text
	return block

static func loop(count:int, blocks:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.LOOP
	block.block_text = "PARA_FAÇA"
	block.loop_count = count
	block.child_blocks = blocks
	return block

static func while_do(condition_name:String, blocks:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.WHILE
	block.block_text = "ENQUANTO"
	block.condition[0] = condition_name
	block.child_blocks = blocks
	return block

static func if_else(condition_name:String, if_blocks:Array[BlockData] = [], else_b:Array[BlockData] = []) -> BlockData:
	var block = BlockData.new()
	block.type = Type.IF
	block.block_text = "SE_SENÃO"
	block.condition[0] = condition_name
	block.child_blocks = if_blocks
	block.else_blocks = else_b
	return block

static func function(s_block:BlockData = null, func_name:String = "F1") -> BlockData:
	var block = BlockData.new()
	block.name = func_name
	block.type = Type.FUNCTION
	block.block_text = func_name + "()"
	block.child_blocks.append(s_block)
	block.color = Color("#b685d1")
	return block
