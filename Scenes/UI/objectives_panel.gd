extends PanelContainer

const objective_node = preload("res://Scenes/UI/objective.tscn")
@onready var lvl_info = $VFlow/LvlInfo
@onready var list = $VFlow/List

func _ready():
	clear_list()

func clear_list() -> void:
	for obj in list.get_children():
		obj.queue_free()
