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

#region CMD SIGNALS
signal update_info_text(info:String)
signal new_translation(translation:String)
signal request_translation(to:String)
signal stop_execution
signal drag_block(drag:bool)
#endregion

signal console_message(msg: String)
