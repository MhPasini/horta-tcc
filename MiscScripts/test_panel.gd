extends Control


@onready var x = $Panel/VBoxContainer/Coords/X
@onready var y = $Panel/VBoxContainer/Coords/Y
@onready var option_button = $Panel2/VBoxContainer/OptionButton

@onready var plantar_btn = $Functions/PlantarBtn

var cell_x : int
var cell_y : int
var seed_type : int

func get_input_values() -> void:
	cell_x = int(x.text)
	cell_y = int(y.text)
	seed_type = option_button.selected + 1

func _on_plantar_btn_pressed():
	Events.test_plant.emit(seed_type)

func _on_regar_btn_pressed():
	Events.test_water.emit()

func _on_colher_btn_pressed():
	Events.test_harvest.emit()

func _on_move_btn_pressed():
	get_input_values()
	Events.test_move.emit(Vector2i(cell_x,cell_y))

func _on_origin_btn_pressed():
	Events.test_move_origin.emit()

func _on_move_next_btn_pressed():
	Events.test_move_next.emit()

func _on_move_previous_btn_pressed():
	Events.test_move_previous.emit()
