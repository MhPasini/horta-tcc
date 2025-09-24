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
	Events.update_grid.connect(_on_update_grid)

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

func reset_grid() -> void:
	for x in size.x:
		for y in size.y:
			var slot = grid.get_cell_value(Vector2i(x, y)) as FarmSlot
			slot.reset_crop()

func plant_crop_at(cell: Vector2i, seed_type: int) -> LogResult:
	var slot = grid.get_cell_value(cell) as FarmSlot
	return slot.plant_crop(seed_type) as LogResult

func water_crop_at(cell: Vector2i) -> LogResult:
	var slot = grid.get_cell_value(cell) as FarmSlot
	return slot.water_crop() as LogResult

func harvest_crop_at(cell: Vector2i) -> LogResult:
	var slot = grid.get_cell_value(cell) as FarmSlot
	return slot.harvest_crop() as LogResult

func _on_update_grid(cell:Vector2i, vars:Array) -> void:
	var slot = grid.get_cell_value(cell) as FarmSlot
	slot.curr_crop = vars[0]
	slot.grow_level = vars[1]
	slot.water_level = vars[2]

func _thread_done():
	thread.wait_to_finish()
