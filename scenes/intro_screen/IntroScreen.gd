extends CanvasLayer
onready var lblLevelNum = get_node("root/VBoxContainer/lblLevelNum")
onready var lblFloatersNum = get_node("root/VBoxContainer/lblFloatersNum")
onready var lblAttemptsNum = get_node("root/VBoxContainer/lblAttemptsNum")

# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.connect("floater_num_changed", self, "update_ui")
	EventManager.connect("restart_level", self, "update_ui")
	update_ui()

func update_ui():
	lblLevelNum.text = str(GameData.get_level() + 1)
	lblFloatersNum.text = str(GameData.get_num_floaters())
	lblAttemptsNum.text = str(GameData.get_num_attempts())

func hide():
	get_child(0).visible = false
	
func show():
	get_child(0).visible = true

