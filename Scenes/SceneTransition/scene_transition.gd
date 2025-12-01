extends Node

const game_scene = preload("res://Scenes/Game/game.tscn")
const menu_scene = preload("res://Scenes/Menu/menu.tscn")


func change_to_scene(new:String, pattern:String = "", color:Color = Color.BLACK,
 smooth:bool = false, fade_time:float = 0.75) -> void:
	var new_scene = select_scene(new)
	SoundManager.play_sfx("res://Sounds&Music/Transition_1.wav")
	await Fade.fade_out(fade_time, color, pattern, false, smooth).finished
	await create_tween().tween_interval(0.2).finished
	get_tree().change_scene_to_packed(new_scene)
	Fade.fade_in(fade_time, color, pattern, false, smooth)

func select_scene(scene:String) -> PackedScene:
	var s : PackedScene
	if scene == "menu":
		s = menu_scene
	elif scene == "game":
		s = game_scene
	return s
