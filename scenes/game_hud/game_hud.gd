extends CanvasLayer

onready var lblFloaters = get_node("MarginContainer/root/lblFloaters") 

var bar_red = preload("res://assets/ui/red_bar.png")
var bar_green = preload("res://assets/ui/green_bar.png")
var bar_yellow = preload("res://assets/ui/yellow_bar.png")

onready var energy_progress = get_node("MarginContainer/root/prgEnergy")

func _ready():
	EventManager.connect("floater_num_changed", self, "on_floater_changed")
	EventManager.connect("energy_changed", self, "on_energy_changed")
	energy_progress.max_value = 100.0
	
func on_energy_changed():
	var energy = GameData.get_energy()
	if energy < 20.0:
		energy_progress.texture_progress = bar_red
	elif energy < 50.0:
		energy_progress.texture_progress = bar_yellow
	else:
		energy_progress.texture_progress = bar_green
	
	energy_progress.value = energy
	

func on_floater_changed():
	lblFloaters.text = str(GameData.get_num_floaters())
	
