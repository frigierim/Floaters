extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hide():
	get_child(0).visible = false
	
func show():
	get_child(0).visible = true
	get_node("root/VBoxContainer/btnRestart").grab_focus()


func _on_btnMenu_pressed():
	get_tree().change_scene("res://scenes/mainmenu/mainmenu.tscn")


func _on_btnRestart_pressed():
	GameData.round_restart()
	get_tree().change_scene("res://scenes/gamemap/GameMap.tscn")
	
