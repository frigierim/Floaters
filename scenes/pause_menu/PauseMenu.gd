extends CanvasLayer

func hide():
	get_child(0).visible = false
	get_tree().paused = false
	
func show():
	get_child(0).visible = true
	get_node("Control/CenterContainer/VBoxContainer/btnContinue").grab_focus()
	get_tree().paused = true

func _on_btnContinue_pressed():
	hide()

func _on_btnQuit_pressed():
	hide()
	get_tree().change_scene("res://scenes/mainmenu/mainmenu.tscn")
