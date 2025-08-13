extends Node
class_name FarmGrid

@export var size: Vector2i
@export var gridOffset: Vector2i
@export var slot_scene: PackedScene = preload("res://Scenes/FarmSlots/slot.tscn") 

var grid : Grid = Grid.new()
var thread = Thread.new()

func  _ready() -> void:
	grid.size = size
	grid.offset = gridOffset
	if thread.is_alive():
		return
	thread.start(_place_farm_slots)
	Events.test_plant.connect(plant_crop_at)

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

func plant_crop_at(cell: Vector2i, seed_type: int):
	if grid.is_inside_grid(cell):
		var c = grid.get_cell_value(cell) as FarmSlot
		var err = c.plant_crop(seed_type)
		print(err)
	else:
		print("Coordenadas do canteiro incorretas!")

func _thread_done():
	thread.wait_to_finish()
