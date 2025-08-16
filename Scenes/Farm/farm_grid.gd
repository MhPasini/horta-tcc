extends Node
class_name FarmGrid

@export var size: Vector2i = Vector2i(6, 6)
@export var gridOffset: Vector2i = Vector2i(42, 102)
@export var slot_scene: PackedScene = preload("res://Scenes/FarmSlots/slot.tscn") 

var grid : Grid = Grid.new()
var thread = Thread.new()

func  _ready() -> void:
	grid.size = size
	grid.offset = gridOffset
	if thread.is_alive():
		return
	thread.start(_place_farm_slots)
	Events.test_plant.connect(_plant_crop_at)
	Events.test_water.connect(_water_crop_at)
	Events.test_harvest.connect(_harvest_crop_at)

func _place_farm_slots() -> void:
	for x in size.x:
		for y in size.y:
			var cell = Vector2i(x, y)
			var slot = slot_scene.instantiate() as FarmSlot
			slot.position = grid.grid_to_world(cell)
			slot.grid_pos = cell
			grid.update_cell(cell, slot)
			call_deferred("add_child", slot)
	call_deferred("_thread_done")

func _plant_crop_at(cell: Vector2i, seed_type: int) -> void:
	if grid.is_inside_grid(cell):
		var slot = grid.get_cell_value(cell) as FarmSlot
		slot.plant_crop(seed_type)
	else:
		send_error_message()

func _water_crop_at(cell: Vector2i) -> void:
	if grid.is_inside_grid(cell):
		var slot = grid.get_cell_value(cell) as FarmSlot
		slot.water_crop()
	else:
		send_error_message()

func _harvest_crop_at(cell: Vector2i) -> void:
	if grid.is_inside_grid(cell):
		var slot = grid.get_cell_value(cell) as FarmSlot
		slot.harvest_crop()
	else:
		send_error_message()

func send_error_message() -> void:
	var msg_type = "[color=red]ERRO: [/color]"
	var msg = "Canteiro fora da área delimitada, ação cancelada!"
	Events.console_message.emit(msg_type + msg)

func _thread_done():
	thread.wait_to_finish()
