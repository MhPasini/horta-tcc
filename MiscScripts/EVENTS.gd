extends Node

signal test_plant(cell:Vector2i, seed:int)
signal test_water(cell:Vector2i)
signal test_harvest(cell:Vector2i)
signal test_move(cell:Vector2i)
signal test_move_origin
signal test_move_next
signal test_move_previous

signal console_message(msg: String)
signal task_completed
