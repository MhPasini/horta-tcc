extends Resource
class_name Grid

@export var size := Vector2i(8, 8) # grid dimensions in cells
@export var cell_size := Vector2(26, 26) # cell size in pixels
@export var offset := Vector2(0, 0) # grid origin offset in pixels

var grid_array = []
var half_cell = cell_size/2

func _init():
	grid_array = make_2d_array()

func world_to_grid(pos:Vector2) -> Vector2:
	return ((pos - offset) / cell_size).floor()

func grid_to_world(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + half_cell + offset

func update_cell(cell:Vector2i, value) -> void:
	grid_array[cell.x][cell.y] = value

func get_cell_value(cell:Vector2i):
	if is_instance_valid(grid_array[cell.x][cell.y]):
		return grid_array[cell.x][cell.y]
	else:
		return null

func is_cell_null(cell:Vector2i) -> bool:
	if grid_array[cell.x][cell.y] == null:
		return true
	else :
		return false

func is_inside_grid(cell:Vector2i) -> bool:
	return not (
		cell.x < 0 or
		cell.y < 0 or
		cell.x >= size.x or
		cell.y >= size.y
	)

func make_2d_array() -> Array:
	var array = []
	for i in size.x:
		array.append([])
		for j in size.y:
			array[i].append(null)
	return array
