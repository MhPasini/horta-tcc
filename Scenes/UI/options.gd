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
			queue_free()

func _on_continue_pressed():
	queue_free()

func _on_lvl_selector_pressed():
	var s = lv_selector.instantiate()
	self.add_sibling(s)

func _on_menu_pressed():
	SceneTransition.change_to_scene("menu", "Diamond")

func _on_sfx_button_toggled(toggled_on):
	Globals.sfx_on = toggled_on

func _on_bgm_button_toggled(toggled_on):
	Globals.bgm_on = toggled_on

func _on_close_app_pressed():
	$Panel/Btns/CloseApp/HBox.show()
	$Panel/Btns/CloseApp.text = ""

func _on_confirm_pressed():
	# save all progress
	get_tree().quit()

func _on_cancel_pressed():
	$Panel/Btns/CloseApp/HBox.hide()
	$Panel/Btns/CloseApp.text = "Encerrar App"
