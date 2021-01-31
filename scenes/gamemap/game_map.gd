extends Node2D


var bg_speed_scale : float = 0.1

var screens: int  = 3
onready var bkgnd = get_node("background")
onready var objects_layer = get_node("objects")
onready var gameovermenu = get_node("EndMenu")
onready var intro_timer = get_node("IntroTimer")
onready var intro_screen = get_node("IntroScreen")
onready var player = get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.connect("changed_speed", self, "_on_speed_changed")
	EventManager.connect("changed_position", self, "_on_position_changed")
	EventManager.connect("game_over", self, "_on_game_over")
	EventManager.connect("round_complete", self, "_on_round_complete")

	intro_timer.connect("timeout", self, "_on_intro_timer_complete")
	begin_round()


func _on_speed_changed(newSpeed : Vector2):	
	pass
	
func _on_position_changed(newOffset : Vector2):	
	var mat = bkgnd.get_material()
	var newVect = Vector3(newOffset.x, -newOffset.y, 0) * bg_speed_scale
	mat.set_shader_param("ScrollOffset", newVect)
	

func _on_game_over():
	gameovermenu.show()

func _process(delta):
	if player.is_alive():
		GameData.draw_energy(delta)

func begin_round():
	var mat = bkgnd.get_material()
	mat.set_shader_param("ScrollSpeed",Vector3(0.0,0.0,0.0))
	mat.set_shader_param("ScrollOffset",Vector3(0.0,0.0,0.0))
	
	var game_area = Rect2(-1024, -1024, 1024, 1024)
	GameData.restart_level(objects_layer,game_area)
	gameovermenu.hide()
	
	intro_timer.start()
	intro_screen.show()
	get_tree().paused = true
	
		
	
func _on_round_complete():
	begin_round()
	
func _on_intro_timer_complete():
	get_tree().paused = false
	intro_screen.hide()
