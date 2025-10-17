extends Control

const code_tab = preload("res://Scenes/UI/code_tab.tscn")
const func_side_block = preload("res://Scenes/Blocks/func_block.tscn")

var robot : RobotClass
var program : Array[BlockData] = []
var stop_requested : bool = false
var state = IDLE

@onready var code_container = $CodePanel/CodeTabs/Main/CodeContainer as CodeContainer
@onready var info_text = $InfoPanel/Info

enum {PLAYING, IDLE}

func _ready():
	robot = Globals.robot_ref
	connect_signals()
	set_play_pause_visibility(false)
	Globals.cmd_panel = self

func connect_signals() -> void:
	Events.update_info_text.connect(_update_info_text)
	Events.create_new_function.connect(_on_create_new_function)
	code_container.code_list_updated.connect(_on_code_list_updated)

func run_program() -> void:
	var _ok : bool = true
	robot.send_log_message("[color=green]*Início do programa*[/color]")
	for block in program:
		_ok = await _execute(block)
		if not _ok or stop_requested:
			break
		await create_tween().tween_interval(.25).finished
	if not _ok or stop_requested:
		robot.send_log_message("[color=red]*Execução terminada*[/color]")
	else :
		robot.send_log_message("[color=green]*Fim do programa*[/color]")
	state = IDLE
	set_play_pause_visibility(false)

func _execute(block:BlockData) -> bool:
	var _ok : bool = true
	if stop_requested: return false
	match block.type:
		block.Type.METHOD:
			match block.name:
				"move_to":
					_ok = await robot.call(block.name, block.pos)
				"plant_crop":
					_ok = await robot.call(block.name, block.plant_seed)
				"wait_for":
					_ok = await robot.call(block.name, block.wait_time)
				_ :
					_ok = await robot.call(block.name)
			#robot.send_stat_update()
			#print("Cmd %s: " % block.name, _ok)
		block.Type.LOOP:
			for i in range(block.loop_count):
				for child in block.child_blocks:
					_ok = await _execute(child)
		block.Type.WHILE:
			var max_iterations = 255
			var iterations = 0
			while _check_condition(block.condition) and iterations < max_iterations:
				for child in block.child_blocks:
					_ok = await _execute(child)
					if not _ok: return false
				iterations += 1
			if iterations >= max_iterations:
				var msg = "Execução do código interrompida, loop >= %d" % max_iterations
				print(msg)
				robot.send_log_message(msg, Globals.MSG_TYPE.error)
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
				print("Func %s: " % block.name, _ok)
	return _ok

func _on_code_list_updated(_code_container) -> void:
	update_program()

func update_program() -> void:
	program = code_container.get_code_blocks()
	if program.size() > 0: $Tooltip.hide()
	else: $Tooltip.show()

func clear_program() -> void:
	program.clear()
	code_container.clear_code_blocks()
	$Tooltip.show()

func _on_create_new_function(block) -> void:
	var new_tab = code_tab.instantiate()
	var tab_name = get_valid_name()
	new_tab.name = tab_name
	$CodePanel/CodeTabs.add_child(new_tab)
	var container = new_tab.get_child(0) as CodeContainer
	container.func_container = true
	new_tab.add_to_group(tab_name)
	var f_data : BlockData
	if block is CodeBlock:
		var old_container = block.parent_container
		var list_index = block.get_index()
		container.add_code_block(block)
		f_data = BlockData.function(block.block_data, tab_name)
		f_data.func_container = container
		old_container.create_code_block(f_data, list_index)
	elif block is BlockData:
		f_data = BlockData.function(block, tab_name)
		f_data.func_container = container
		container.create_code_block(block)
	create_side_func_block(f_data, tab_name)

func create_side_func_block(f_data:BlockData, tab_name: String) -> void:
	var f_sb = func_side_block.instantiate()
	f_sb.data = f_data
	f_sb.add_to_group(tab_name)
	$BlocksPanel/VBox/ScrollContainer/Blocks.add_child(f_sb)

func set_play_pause_visibility(playing:bool) -> void:
	$BtnsArea/Play.visible = not playing
	$BtnsArea/Stop.visible = playing

func _check_condition(condition:Array) -> bool:
	if robot and robot.has_method(condition[0]):
		if condition[1] != null:
			return robot.call(condition[0], condition[1])
		else :
			return robot.call(condition[0], condition[2])
	else:
		print("Condição não encontrada: ", condition)
		return false

func get_valid_name() -> String:
	var counter = 1
	var valid_name = ""
	while true:
		valid_name = "F%d" % counter
		if not Globals.func_list.has(valid_name):
			break
		counter += 1
	Globals.func_list.append(valid_name)
	return valid_name

func _update_info_text(new_info:String) -> void:
	info_text.text = new_info

func _on_play_pressed() -> void:
	stop_requested = false
	state = PLAYING
	set_play_pause_visibility(true)
	update_program()
	run_program()

func _on_clear_pressed():
	if state == PLAYING:
		robot.send_log_message("[color=Orange]*Parada requisitada*[/color]")
	stop_requested = true
	clear_program()

func _on_stop_pressed():
	robot.send_log_message("[color=Orange]*Parada requisitada*[/color]")
	stop_requested = true

func _on_code_tabs_tab_changed(tab):
	Globals.active_code_tab = tab
	Events.code_tab_changed.emit(tab)
