extends Node

@onready var start_position = $StartPosition.position
@onready var robot : RobotClass = $Robot
@onready var farm : FarmGrid = $FarmGrid

func _ready():
	robot.position = start_position
	robot.rest_position = start_position
	robot.farm = farm
