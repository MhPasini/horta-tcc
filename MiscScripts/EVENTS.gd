extends Node

#region test signals
signal test_plant(cell:Vector2i, seed:int)
signal test_water(cell:Vector2i)
signal test_harvest(cell:Vector2i)
signal test_move(cell:Vector2i)
signal test_move_origin
signal test_move_next
signal test_move_previous
#endregion

#region ROBOT SIGNALS
signal move_to(cell:Vector2i)
signal move_origin
signal move_next
signal move_previous
signal plant_crop(crop:String)
signal water_crop
signal harvest_crop
signal task_completed
#endregion

signal console_message(msg: String)
