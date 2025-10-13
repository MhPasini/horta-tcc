extends Node

const lv_selector = preload("res://Scenes/LvlSelector/lvl_selector.tscn")
@onready var sfx_button = $UI/Sounds/SFXButton
@onready var bgm_button = $UI/Sounds/BGMButton

func _ready():
	DataManager.load_data()
	$UI/Panel/Btns/CloseApp/HBox.hide()
	sfx_button.set_pressed_no_signal(Globals.sfx_on)
	bgm_button.set_pressed_no_signal(Globals.bgm_on)
	if OS.has_feature("web"):
		$UI/Panel/Btns/CloseApp.hide()

func _on_play_pressed():
	Globals.level_selected = 0
	SceneTransition.change_to_scene("game", "Diamond")

func _on_lvl_selector_pressed():
	var s = lv_selector.instantiate()
	$UI.add_child(s)

func _on_close_app_pressed():
	$UI/Panel/Btns/CloseApp/HBox.show()
	$UI/Panel/Btns/CloseApp.text = ""

func _on_confirm_pressed():
	# save all progress
	get_tree().quit()

func _on_cancel_pressed():
	$UI/Panel/Btns/CloseApp/HBox.hide()
	$UI/Panel/Btns/CloseApp.text = "SAIR"

func _on_sfx_button_toggled(toggled_on):
	Globals.sfx_on = toggled_on

func _on_bgm_button_toggled(toggled_on):
	Globals.bgm_on = toggled_on
