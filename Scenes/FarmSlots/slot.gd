extends Node2D
class_name FarmSlot

enum DIRT_STATE {Dry, Wet}
enum CROP_STATE {None, Seed, Sprout, Grown}
enum CROPS {None, Carrot, Onion, Radish}

@export var carrot_sprite : Texture = preload("res://Textures/crops/carrot.png")
@export var onion_sprite : Texture = preload("res://Textures/crops/onion.png")
@export var radish_sprite : Texture = preload("res://Textures/crops/radish.png")

var CROP_DATA = {
	CROPS.None:
		['Vazio', null], # Vegetal, Textura
	CROPS.Carrot:
		['Cenoura', carrot_sprite],
	CROPS.Onion:
		['Cebola', onion_sprite],
	CROPS.Radish:
		['Rabanete', radish_sprite]
}

var grid_pos : Vector2i
var curr_crop : int = CROPS.None : set = _set_curr_crop
var curr_crop_state : int = CROP_STATE.None : set = _set_crop_state
var curr_dirt_state : int = DIRT_STATE.Dry : set = _set_dirt_state
var is_dry : bool = true
var is_grown : bool = false

@onready var dirt = $Dirt
@onready var crop = $Crop

func _ready():
	update_dirt_sprite()
	update_crop_sprite()

func plant_crop(seed_type:int):
	if curr_crop == CROPS.None:
		curr_crop = seed_type
		var msg = "Semente de %s plantada no canteiro: %s." % [CROP_DATA[seed_type][0], grid_pos]
		return [true, msg]
	else:
		var msg = "Erro: Já existe uma planta neste canteiro, ação abortada!"
		return [false, msg]


#region UPDATE SPRITES
func update_dirt_sprite() -> void:
	dirt.frame = curr_dirt_state + 1

func update_crop_sprite() -> void:
	crop.texture = CROP_DATA[curr_crop][1]
	if curr_crop_state != CROP_STATE.None:
		crop.frame = curr_crop_state - 1

func _set_curr_crop(value: int) -> void:
	curr_crop = value
	update_crop_sprite()

func _set_crop_state(value: int) -> void:
	curr_crop_state = value
	update_crop_sprite()

func _set_dirt_state(value: int) -> void:
	curr_dirt_state = value
	update_dirt_sprite()
#endregion
