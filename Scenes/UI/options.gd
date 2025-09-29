extends Panel





func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			queue_free()

func _on_continue_pressed():
	queue_free()

func _on_lvl_selector_pressed():
	pass # Replace with function body.

func _on_menu_pressed():
	#scene transition -> start menu
	pass # Replace with function body.

func _on_close_app_pressed():
	$Panel/Btns/CloseApp/HBox.show()
	$Panel/Btns/CloseApp.text = ""

func _on_confirm_pressed():
	# save all progress
	get_tree().quit()

func _on_cancel_pressed():
	$Panel/Btns/CloseApp/HBox.hide()
	$Panel/Btns/CloseApp.text = "Encerrar App"
