extends Node2D
class_name RobotClass

enum STATE {Idle, Moving, Working}
enum CROPS {None, Carrot, Onion, Radish}

var farm : FarmGrid
var state : STATE
var grid_pos : Vector2i
var target_position : Vector2
var rest_position : Vector2
var outside_grid : bool = true
var storage : Dictionary = {
	"Cenoura": 0,
	"Cebola": 0,
	"Rabanete": 0,
}

@export var offset : Vector2 = Vector2()
@export var move_speed : float = 50.0
@export var storage_cap: int = 20

func _ready():
	Globals.robot_ref = self
	set_process(false)
	state = STATE.Idle
	conect_signals()

func _process(delta):
	if state == STATE.Moving:
		position = position.move_toward(target_position, move_speed * delta)
		check_position()

func conect_signals() -> void:
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
	Events.plant_crop.connect(add_crop)
	Events.water_crop.connect(water_crop)
	Events.harvest_crop.connect(harvest_crop)

func move_to(cell:Vector2i) -> void:
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

func move_to_origin() -> void:
	move_to(Vector2(0, 0))

func move_to_next() -> void:
	if outside_grid:
		move_to_origin()
	else :
		move_to(get_next_cell())

func move_to_previous() -> void:
	if outside_grid:
		move_to_origin()
	else :
		move_to(get_previous_cell()) 

#region PLANT FUNCTIONS 
func plant_crop(seed_type:int) -> void:
	if not outside_grid:
		var result : LogResult = farm.plant_crop_at(grid_pos, seed_type)
		if result.type == Globals.MSG_TYPE.error:
			#se der erro, mostrar alguma dica ou informação sobre o erro
			#e cancela as ações seguintes
			pass
		send_log_message(result.msg, result.type)
	else:
		send_log_message("Fora da área delimitada, ação cancelada!", Globals.MSG_TYPE.error)
		#e cancela as ações seguintes
	Events.task_completed.emit()

func water_crop() -> void:
	if not outside_grid:
		var result : LogResult = farm.water_crop_at(grid_pos)
		if result.type == Globals.MSG_TYPE.warning:
			#se der um aviso, mostrar alguma dica ou informação sobre o aviso
			#mas continua o código
			pass
		send_log_message(result.msg, result.type)
	else:
		send_log_message("Fora da área delimitada, ação cancelada!", Globals.MSG_TYPE.error)
		#e cancela as ações seguintes
	Events.task_completed.emit()

func harvest_crop() -> void:
	if not outside_grid:
		var storage_left = get_storage_left()
		var result : LogResult = farm.harvest_crop_at(grid_pos)
		if result.type == Globals.MSG_TYPE.error:
			#se der um erro, mostrar alguma dica ou informação sobre o erro
			#e cancela as ações seguintes
			pass
		elif result.type == Globals.MSG_TYPE.warning:
			#se der um aviso, mostrar alguma dica ou informação sobre o aviso
			#mas continua o código
			pass
		else : # vegetal maduro coletado
			if storage_left <= 0:
				result.msg = "A planta no canteiro %s foi removida, mas não havia espaço para a carregar!" % grid_pos
				result.type = Globals.MSG_TYPE.warning
		send_log_message(result.msg, result.type)
	else:
		send_log_message("Fora da área delimitada, ação cancelada!", Globals.MSG_TYPE.error)
		#e cancela as ações seguintes
	Events.task_completed.emit()
#endregion

func add_crop(crop:String) -> void:
	if get_storage_left() > 0:
		storage[crop] += 1
	#TODO atualizar logs

func check_position() -> void:
	if position == target_position:
		set_process(false)
		state = STATE.Idle
		Events.task_completed.emit()

func get_storage_left() -> int:
	var cargo : int = 0
	for value in storage.values():
		cargo += value
	var storage_left = storage_cap - cargo
	return storage_left

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

func send_log_message(msg:String, type:String = Globals.MSG_TYPE.normal) -> void:
	Events.console_message.emit(type + msg)
