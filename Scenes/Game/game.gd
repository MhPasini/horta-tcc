extends Node

@onready var start_position = $StartPosition.position
@onready var robot = $Robot


func _ready():
	robot.position = start_position
