extends Node

var objectives_list :Array[Objective] = []
var curr_pos : Vector2i = Vector2i.ZERO
var last_move_dir : String = ""
var last_crop : String = ""

func _ready():
	Events.robot_moved_to.connect(_robot_moved_to)
	Events.robot_moved_next.connect(_robot_moved_next)
	Events.robot_moved_previous.connect(_robot_moved_previous)
	Events.robot_planted_at.connect(_robot_planted_at)
	Events.robot_water_at.connect(_robot_water_at)
	Events.robot_harvest_at.connect(_robot_harvest_at)

func clear_data() -> void:
	objectives_list.clear()
	curr_pos = Vector2i.ZERO
	last_move_dir = ""
	last_crop = ""

func _robot_moved_to(new_position: Vector2i):
	print("moved_to: ", new_position)
	curr_pos = new_position
	check_move_objectives()

func _robot_moved_next():
	print("moved_dir: next")
	last_move_dir = "next"
	check_move_objectives()

func _robot_moved_previous():
	print("moved_dir: previous")
	last_move_dir = "previous"
	check_move_objectives()

func _robot_planted_at(cell:Vector2i, crop:String):
	curr_pos = cell
	last_crop = crop
	check_plant_objectives()

func _robot_water_at(cell:Vector2i):
	curr_pos = cell
	check_water_objectives()

func _robot_harvest_at(cell:Vector2i, crop:String):
	curr_pos = cell
	last_crop = crop
	check_harvest_objectives()

func check_move_objectives():
	for objective in objectives_list:
		if objective.completed:
			continue
		for step in objective.steps:
			if step.completed:
				continue
			match step.type:
				"move_to":
					if curr_pos == step.target:
						objective.complete_step(step)
						break
				"move_dir":
					if last_move_dir == step.target:
						last_move_dir = ""
						objective.complete_step(step)
						break
				_:
					pass

func check_water_objectives() -> void:
	for objective in objectives_list:
		if objective.completed:
			continue
		for step in objective.steps:
			if step.completed:
				continue
			match step.type:
				"water_at":
					var t = step.target
					if t is Vector2i:
						if curr_pos == t:
							objective.complete_step(step)
							break
					else:
						objective.complete_step(step)
						break
				_:
					pass

func check_plant_objectives() -> void:
	for objective in objectives_list:
		if objective.completed:
			continue
		for step in objective.steps:
			if step.completed:
				continue
			match step.type:
				"plant_at":
					if (last_crop == step.target_crop or step.target_crop == "any"):
						var t = step.target
						if t is Vector2i:
							if curr_pos == t:
								last_crop = ""
								objective.complete_step(step)
								break
						else:
							last_crop = ""
							objective.complete_step(step)
							break
				_:
					pass

func check_harvest_objectives() -> void:
	for objective in objectives_list:
		if objective.completed:
			continue
		for step in objective.steps:
			if step.completed:
				continue
			match step.type:
				"harvest_at":
					if (last_crop == step.target_crop or step.target_crop == "any"):
						var t = step.target
						if t is Vector2i:
							if curr_pos == t:
								last_crop = ""
								objective.complete_step(step)
								break
						else:
							last_crop = ""
							objective.complete_step(step)
							break
				_:
					pass

func complete_objective(objective:Objective):
	objective.set_completed()
