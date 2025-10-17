extends Node

const SAVE_FILE = "user://saved_data.save"

func save_data() -> void:
	var data = {
		"bgm_on": Globals.bgm_on,
		"sfx_on": Globals.sfx_on,
		"tutorial_on": Globals.tutorial_on,
		"completed_levels": Globals.levels_completed,
	}
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_FILE):
		return
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var data = file.get_var()
	Globals.bgm_on = data.get("bgm_on", true)
	Globals.sfx_on = data.get("sfx_on", true)
	Globals.tutorial_on = data.get("tutorial_on", true)
	Globals.levels_completed = data.get("completed_levels")
	file.close()
