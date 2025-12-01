extends Node

const lv_selector = preload("res://Scenes/LvlSelector/lvl_selector.tscn")
@onready var sfx_button = $UI/Sounds/SFXButton
@onready var bgm_button = $UI/Sounds/BGMButton
@onready var tutorial_check = $UI/Panel/Btns/Tutorial

func _ready():
	DataManager.load_data()
	$UI/Panel/Btns/CloseApp/HBox.hide()
	sfx_button.set_pressed_no_signal(Globals.sfx_on)
	bgm_button.set_pressed_no_signal(Globals.bgm_on)
	tutorial_check.set_pressed_no_signal(Globals.tutorial_on)
	print("Tutorial: ", Globals.tutorial_on)
	if OS.has_feature("web"):
		$UI/Panel/Btns/CloseApp.hide()
	SoundManager.play_bgm("res://Sounds&Music/bgm_loop.wav")

func _on_play_pressed():
	Globals.level_selected = 0
	SceneTransition.change_to_scene("game", "Diamond")
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_01.wav")

func _on_lvl_selector_pressed():
	var s = lv_selector.instantiate()
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_01.wav")
	$UI.add_child(s)

func _on_close_app_pressed():
	$UI/Panel/Btns/CloseApp/HBox.show()
	$UI/Panel/Btns/CloseApp.text = ""
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_01.wav")

func _on_confirm_pressed():
	DataManager.save_data()
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_01.wav")
	get_tree().quit()

func _on_cancel_pressed():
	$UI/Panel/Btns/CloseApp/HBox.hide()
	$UI/Panel/Btns/CloseApp.text = "SAIR"
	SoundManager.play_sfx("res://Sounds&Music/UI/3. Exit & Cancel/Cancel_2.wav")

func _on_sfx_button_toggled(toggled_on):
	Globals.sfx_on = toggled_on
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_12.wav")

func _on_bgm_button_toggled(toggled_on):
	Globals.bgm_on = toggled_on
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_12.wav")

func _on_tutorial_toggled(toggled_on):
	Globals.tutorial_on = toggled_on
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_03.wav")
	print("Tutorial: ", Globals.tutorial_on)
