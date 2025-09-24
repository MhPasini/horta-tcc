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
signal add_crop(crop:String)
signal water_crop
signal harvest_crop
signal task_completed
# OBJECTIVES SIGNALS #
signal robot_moved_to(cell:Vector2i)
signal robot_moved_next
signal robot_moved_previous
signal robot_planted_at(cell:Vector2i, crop:String)
signal robot_water_at(cell:Vector2i)
signal robot_harvest_at(cell:Vector2i, crop:String)

#endregion

#region CMD SIGNALS
signal update_info_text(info:String)
signal new_translation(translation:String)
signal request_translation(to:String)
signal create_new_function(block:CodeBlock)
signal code_tab_changed(tab:int)
signal stop_execution
#endregion

signal console_message(msg: String)
signal level_completed(lvl_ID: int)
#signal update_stat_text(stats:Array)
