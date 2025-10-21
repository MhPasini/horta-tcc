extends Node2D
class_name RobotClass

enum STATE {Idle, Moving, Working}
enum CROPS {None, Carrot, Onion, Radish, Potato, Turnip}

const water_anim = preload("res://Scenes/Animations/water_anim.tscn")
const harvest_anim = preload("res://Scenes/Animations/harvest_anim.tscn")

var farm : FarmGrid
var state : STATE
var grid_pos : Vector2i
var target_position : Vector2
var rest_position : Vector2
var outside_grid : bool = true
var storage_full : bool = false
var storage : Dictionary = {
	"Cenoura": 0,
	"Cebola": 0,
	"Rabanete": 0,
	"Batata": 0,
	"Nabo": 0,
}
var stats : Array
# [pos x, pos y, inv_left, inv_max, slot_seed, is_empty, is_dry, is_grown]
const CROP_DATA = {
	CROPS.None:
		'Vazio',
	CROPS.Carrot:
		'Cenoura',
	CROPS.Onion:
		'Cebola',
	CROPS.Radish:
		'Rabanete',
	CROPS.Potato:
		'Batata',
	CROPS.Turnip:
		'Nabo'
}

@export var offset : Vector2 = Vector2()
@export var move_speed : float = 50.0
@export var storage_cap: int = 50

func _ready():
	Globals.robot_ref = self
	set_process(false)
	state = STATE.Idle
	connect_signals()

func _process(delta):
	if state == STATE.Moving:
		position = position.move_toward(target_position, move_speed * delta)
		check_position()

func connect_signals() -> void:
	Events.test_move.connect(move_to)
	Events.test_move_origin.connect(move_to_origin)
	Events.test_move_next.connect(move_to_next)
	Events.test_move_previous.connect(move_to_previous)
	Events.test_plant.connect(plant_crop)
	Events.test_water.connect(water_crop)
	Events.test_harvest.connect(harvest_crop)
	
	Events.move_to.connect(move_to)
	Events.move_origin.connect(move_to_origin)
	Events.move_next.connect(move_to_next)
	Events.move_previous.connect(move_to_previous)
	Events.add_crop.connect(add_crop)
	Events.water_crop.connect(water_crop)
	Events.harvest_crop.connect(harvest_crop)

func move_to(cell:Vector2i) -> bool:
	if farm.grid.is_inside_grid(cell):
		target_position = farm.grid.grid_to_world(cell) + offset
		state = STATE.Moving
		grid_pos = cell
		set_process(true)
		outside_grid = false
		send_log_message("Movendo robô para %s" % cell)
	else :
		target_position = rest_position
		state = STATE.Moving
		set_process(true)
		outside_grid = true
		send_log_message("%s fora da área delimitada, voltando para base!" % cell, Globals.MSG_TYPE.warning)
	await Events.task_completed
	if !outside_grid:
		Events.robot_moved_to.emit(grid_pos)
	return true

func move_to_origin() -> bool:
	var result = await move_to(Vector2(0, 0))
	return result

func move_to_next() -> bool:
	var result : bool
	if outside_grid:
		result = await move_to_origin()
	else :
		result = await move_to(get_next_cell())
		Events.robot_moved_next.emit()
	return result

func move_to_previous() -> bool:
	var result : bool
	if outside_grid:
		result = await move_to_origin()
	else :
		result = await move_to(get_previous_cell())
		Events.robot_moved_previous.emit()
	return result

func wait_for(time:float) -> bool:
	await create_tween().tween_interval(time).finished
	return true

#region PLANT FUNCTIONS 
func plant_crop(seed_type:int) -> bool:
	await create_tween().tween_interval(.2).finished
	if not outside_grid:
		var result : LogResult = farm.plant_crop_at(grid_pos, seed_type)
		if result.type == Globals.MSG_TYPE.error:
			send_log_message(result.msg, result.type)
			#se der erro, mostrar alguma dica ou informação sobre o erro
			#await error animation
			return false
		else:
			send_log_message(result.msg, result.type)
			Events.robot_planted_at.emit(grid_pos, CROP_DATA[seed_type])
			await create_tween().tween_interval(0.8).finished
	else:
		send_log_message("Fora da área delimitada, ação cancelada!", Globals.MSG_TYPE.error)
		#await error animation
		return false
	return true

func water_crop() -> bool:
	if not outside_grid:
		var result : LogResult = farm.water_crop_at(grid_pos)
		if result.type == Globals.MSG_TYPE.warning:
			pass
		var anim = water_anim.instantiate()
		add_child(anim)
		await create_tween().tween_interval(1.1).finished
		send_log_message(result.msg, result.type)
		Events.robot_water_at.emit(grid_pos)
	else:
		send_log_message("Fora da área delimitada, ação cancelada!", Globals.MSG_TYPE.error)
		#await error animation
		return false
	return true

func harvest_crop() -> bool:
	if not outside_grid:
		var storage_left = get_storage_left()
		var result : LogResult = farm.harvest_crop_at(grid_pos)
		if result.type == Globals.MSG_TYPE.warning:
			#await warning animation
			#se der um aviso, mostrar alguma dica ou informação sobre o aviso
			pass
		else : # vegetal maduro coletado
			var anim = harvest_anim.instantiate()
			add_child(anim)
			await create_tween().tween_interval(1.1).finished
			if storage_left <= 0:
				result.msg = "A planta no canteiro %s foi removida, mas não havia espaço para a carregar!" % grid_pos
				result.type = Globals.MSG_TYPE.warning
				#await warning animation
		send_log_message(result.msg, result.type)
	else:
		send_log_message("Fora da área delimitada, ação cancelada!", Globals.MSG_TYPE.error)
		#await error animation
		return false
	return true
#endregion

#region CHECK CONDITIONS
func lote_vazio(v:bool) -> bool:
	var slot = farm.grid.get_cell_value(grid_pos) as FarmSlot
	return (slot.is_empty == v)

func lote_seco(v:bool) -> bool:
	var slot = farm.grid.get_cell_value(grid_pos) as FarmSlot
	return (slot.is_dry == v)

func planta_ok(v:bool) -> bool:
	var slot = farm.grid.get_cell_value(grid_pos) as FarmSlot
	return (slot.is_grown == v)

func robo_cheio() -> bool:
	return storage_full

func pos_x_igual(x:int = 0) -> bool:
	return grid_pos.x == x

func pos_x_maior_igual(x:int = 0) -> bool:
	return grid_pos.x >= x

func pos_x_menor_igual(x:int = 0) -> bool:
	return grid_pos.x <= x

func pos_x_maior(x:int = 0) -> bool:
	return grid_pos.x > x

func pos_x_menor(x:int = 0) -> bool:
	return grid_pos.x < x

func pos_x_diferente(x:int = 0) -> bool:
	return grid_pos.x != x

func pos_y_igual(y:int = 0) -> bool:
	return grid_pos.y == y

func pos_y_maior_igual(y:int = 0) -> bool:
	return grid_pos.y >= y

func pos_y_menor_igual(y:int = 0) -> bool:
	return grid_pos.y <= y

func pos_y_maior(y:int = 0) -> bool:
	return grid_pos.y > y

func pos_y_menor(y:int = 0) -> bool:
	return grid_pos.y < y

func pos_y_diferente(y:int = 0) -> bool:
	return grid_pos.y != y

#endregion

func add_crop(crop:String) -> void:
	if get_storage_left() > 0:
		storage[crop] += 1
	Events.robot_harvest_at.emit(grid_pos, crop)
	Events.update_storage.emit(storage)

func check_position() -> void:
	if position == target_position:
		set_process(false)
		state = STATE.Idle
		Events.task_completed.emit()

func get_storage_left() -> int:
	var storage_left = 10 #storage_cap - get_storage()
	storage_full = (storage_left <= 0)
	return storage_left

func get_storage() -> int:
	var cargo : int = 0
	for value in storage.values():
		cargo += value
	return cargo

func get_next_cell() -> Vector2i:
	var next = Vector2i()
	var farm_size = farm.size
	next = grid_pos
	next.x += 1
	if next.x >= farm_size.x:
		next.x = 0
		next.y += 1
	if next.y >= farm_size.y:
		next.y = 0
	return next

func get_previous_cell() -> Vector2i:
	var previous = Vector2i()
	var farm_size = farm.size
	previous = grid_pos
	previous.x -= 1
	if previous.x < 0:
		previous.x = farm_size.x - 1
		previous.y -= 1
	if previous.y < 0:
		previous.y = farm_size.y - 1
	return previous

func get_seed_type() -> String:
	var slot = farm.grid.get_cell_value(grid_pos) as FarmSlot
	return slot.get_crop_name()

func send_log_message(msg:String, type:String = Globals.MSG_TYPE.normal) -> void:
	Events.console_message.emit(type + msg)

func reset_vars() -> void:
	for key in storage:
		storage[key] =  0
	position = rest_position
	grid_pos = Vector2i.ZERO
	outside_grid = true

#func send_stat_update() -> void:
	#stats = [
		#grid_pos.x, grid_pos.y, get_storage(), storage_cap,
		#get_seed_type(), lote_vazio(), lote_seco(), planta_ok(),
		#outside_grid]
	#Events.update_stat_text.emit(stats)
