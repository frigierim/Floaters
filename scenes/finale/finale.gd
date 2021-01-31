extends Control

func _ready():
	get_node("CenterContainer/VBoxContainer/TextureButton").grab_focus()

func _on_TextureButton_pressed():
	get_tree().quit()
