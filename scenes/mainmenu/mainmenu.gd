extends Control

onready var btnRestart = get_node("MarginContainer/VBoxContainer/HBoxContainer/btnRestart")

# Called when the node enters the scene tree for the first time.
func _ready():
	btnRestart.grab_focus()
	
	# Verify configuration and check if a saved status is present
	# Disable the resume game button accordingly

func _on_btnRestart_pressed():
	GameData.reset_game_data()
	EventManager.emit_signal("new_game")
	get_tree().change_scene("res://scenes/gamemap/GameMap.tscn")
	
func _on_btnContinue_pressed():
	EventManager.emit_signal("new_game")
	get_tree().change_scene("res://scenes/gamemap/GameMap.tscn")

func _on_btnQuit_pressed():
	get_tree().quit(0)
