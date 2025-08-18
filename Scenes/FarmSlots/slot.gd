extends Node2D
class_name FarmSlot

enum DIRT_STATE {Dry, Wet}
enum CROP_STATE {Seed, Sprout, Grown}
enum CROPS {None, Carrot, Onion, Radish}

const error_msg = "[color=red]ERRO: [/color]"
const warning_msg = "[color=yellow]AVISO: [/color]"

@export var carrot_sprite : Texture = preload("res://Textures/crops/carrot.png")
@export var onion_sprite : Texture = preload("res://Textures/crops/onion.png")
@export var radish_sprite : Texture = preload("res://Textures/crops/radish.png")

var CROP_DATA = {
	CROPS.None:
		['Vazio', null, 0.0, 0.25], # Vegetal, Textura, GrowLimit, GrowRate
	CROPS.Carrot:
		['Cenoura', carrot_sprite, 10.0, 1.0],
	CROPS.Onion:
		['Cebola', onion_sprite, 10.0, 0.5],
	CROPS.Radish:
		['Rabanete', radish_sprite, 20.0, 0.75]
}

var grid_pos : Vector2i
var curr_crop : int = CROPS.None : set = _set_curr_crop
var curr_crop_state : int = CROP_STATE.Seed : set = _set_crop_state
var curr_dirt_state : int = DIRT_STATE.Dry : set = _set_dirt_state
var water_level : float = 0.0 : set = _set_water_lvl
var grow_level : float = 0.0 : set = _set_grow_lvl
var is_dry : bool = false
var is_grown : bool = false
var is_empty : bool = false

@onready var dirt_sprite = $Dirt
@onready var crop_sprite = $Crop
@onready var water_indicator = $Control/WaterIndicator
@onready var growth_indicator = $Control/GrowthIndicator


func _ready():
	set_initial_values()
	set_process(false)

func _process(delta):
	grow_crop(delta)

func set_initial_values() -> void:
	curr_crop = CROPS.None
	curr_crop_state = CROP_STATE.Seed
	curr_dirt_state = DIRT_STATE.Dry
	water_indicator.hide()
	growth_indicator.hide()

func plant_crop(seed_type:int):
	var msg : String
	if curr_crop == CROPS.None:
		curr_crop = seed_type
		curr_crop_state = CROP_STATE.Seed
		msg = "Semente de %s plantada no canteiro: %s." % [CROP_DATA[seed_type][0], grid_pos]
		Events.console_message.emit(msg)
		#TODO animação de plantar a semente
	else:
		msg = "Já existe uma planta no canteiro %s, ação abortada!"% grid_pos
		Events.console_message.emit(error_msg + msg)

func water_crop():
	water_level = 10.0
	curr_dirt_state = DIRT_STATE.Wet
	water_indicator.show()
	set_process(true)
	#TODO animação de plantar a semente
	var msg = "Canteiro %s regado." % grid_pos
	Events.console_message.emit(msg)

func harvest_crop():
	var msg : String
	if curr_crop == CROPS.None:
		msg = "Não há nenhuma planta no canteiro %s, ação abortada!"% grid_pos
		Events.console_message.emit(error_msg + msg)
	elif not is_grown:
		msg = "A planta no canteiro %s foi removida, mas não estava madura!"% grid_pos
		Events.console_message.emit(warning_msg + msg)
		reset_crop()
		#TODO animação de remover planta
	else:
		msg = "%s coletado(a) no canteiro: %s." % [CROP_DATA[curr_crop][0], grid_pos]
		Events.console_message.emit(msg)
		reset_crop()
		#TODO enviar uma planta para o armazem do robô
		#TODO animação de colher planta
	print(msg)

func reset_crop() -> void:
	curr_crop = CROPS.None
	grow_level = 0.0
	is_grown = false
	growth_indicator.hide()

func grow_crop(delta:float):
	var grow_rate = CROP_DATA[curr_crop][3]
	water_level -= grow_rate * delta
	if not (is_empty or is_grown):
		grow_level += grow_rate * delta

#region UPDATE SPRITES
func update_dirt_sprite() -> void:
	dirt_sprite.frame = curr_dirt_state + 1

func update_crop_sprite() -> void:
	crop_sprite.texture = CROP_DATA[curr_crop][1]
	crop_sprite.frame = curr_crop_state
#endregion

#region SETTERS
func _set_curr_crop(value: int) -> void:
	curr_crop = value
	is_empty = not bool(value)
	update_crop_sprite()

func _set_crop_state(value: int) -> void:
	curr_crop_state = value
	update_crop_sprite()

func _set_dirt_state(value: int) -> void:
	curr_dirt_state = value
	is_dry = not bool(value)
	update_dirt_sprite()

func _set_water_lvl(value: float) -> void:
	water_level = maxf(value, 0.0)
	water_indicator.value = water_level
	if water_level <= 0.0:
		set_process(false)
		water_indicator.hide()
		curr_dirt_state = DIRT_STATE.Dry

func _set_grow_lvl(value: float) -> void:
	var grow_limit = CROP_DATA[curr_crop][2]
	grow_level = minf(value, grow_limit)
	if grow_level >= grow_limit:
		curr_crop_state = CROP_STATE.Grown
		growth_indicator.show()
		is_grown = true
	elif grow_level >= 5.0:
		curr_crop_state = CROP_STATE.Sprout

#endregion
