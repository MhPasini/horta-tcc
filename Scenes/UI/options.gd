extends Panel

const lv_selector = preload("res://Scenes/LvlSelector/lvl_selector.tscn")

var in_menu :bool = false

func _ready():
	$Panel/Btns/Sounds/SFXButton.set_pressed_no_signal(Globals.sfx_on)
	$Panel/Btns/Sounds/BGMButton.set_pressed_no_signal(Globals.bgm_on)
	if in_menu:
		$Panel/Btns/CloseApp.hide()
	if OS.has_feature("web"):
		$Panel/Btns/CloseApp.hide()

func _on_gui_input(event):
	if event is InputEvent:
		if event.is_action_pressed("click"):
			SoundManager.play_sfx("res://Sounds&Music/UI/3. Exit & Cancel/Cancel_2.wav")
			queue_free()

func _on_continue_pressed():
	queue_free()

func _on_lvl_selector_pressed():
	var s = lv_selector.instantiate()
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_01.wav")
	self.add_sibling(s)

func _on_menu_pressed():
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_01.wav")
	SceneTransition.change_to_scene("menu", "Diamond")

func _on_sfx_button_toggled(toggled_on):
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_12.wav")
	Globals.sfx_on = toggled_on

func _on_bgm_button_toggled(toggled_on):
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_12.wav")
	Globals.bgm_on = toggled_on

func _on_close_app_pressed():
	$Panel/Btns/CloseApp/HBox.show()
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_01.wav")
	$Panel/Btns/CloseApp.text = ""

func _on_confirm_pressed():
	SoundManager.play_sfx("res://Sounds&Music/Menu_UI_Beeps/retro_ui_menu_simple_click_01.wav")
	DataManager.save_data()
	get_tree().quit()

func _on_cancel_pressed():
	$Panel/Btns/CloseApp/HBox.hide()
	$Panel/Btns/CloseApp.text = "Encerrar App"
	SoundManager.play_sfx("res://Sounds&Music/UI/3. Exit & Cancel/Cancel_2.wav")
	
