extends Node

# Initialize with default configuration
var default_user_data : Dictionary = {
	"config" : 
	{
		"level"  	: 0,      
		"volume" 	: 0.5,	# linear, from 0.0 to 1.0
		"floaters" 	: 0,	# floaters left in this level
		"attempts"	: 0,	# number of attempts to clear this level
		"energy"	: 0.0	# energy left in current run
	}
}

var MAX_LEVELS = 5

var ENERGY_DRAW : float = 0.01

# TBD: Balance something :D

var ENERGY_BONUS = [
	50.0,
	40.0, 
	30.0,
	20.0,
	10.0	
]

var ROCKS = [
	20,
	40, 
	90,
	120,
	150	
]

var FLOATERS = [
	10,
	20, 
	30,
	40,
	50	
]

var BOUNDS_EXTENDERS = [
	3,
	4, 
	5,
	6,
	7	
]


var user_data : Dictionary = default_user_data 

func _ready():
	
	randomize()
	var save_file : File = File.new()
	if save_file.open("user://game_data.json", File.READ) == OK:
		var parser_res = JSON.parse(save_file.get_as_text())
		save_file.close()
		user_data = parser_res.get_result()
		
	EventManager.connect("floater_collected", self, "on_floater_collected")
	EventManager.connect("round_complete", self, "on_round_complete")

func save_game_data():

	var save_file : File = File.new()
	
	if save_file.open("user://game_data.json", File.WRITE) == OK:
		save_file.store_string(to_json(user_data))
		save_file.close()

# Data getters and setters #####################################################

func get_level() -> int:
	if user_data["config"].has("level"):
		return user_data["config"]["level"]
	return 0

func set_level(level : int):
	user_data["config"]["level"] = level
	
func get_music_volume() -> float:
	if user_data["config"].has("volume"):
		return user_data["config"]["volume"]
	return 0.0

func set_music_volume(vol : float):
	user_data["config"]["volume"] = vol

func get_num_floaters() -> int:
	if user_data["config"].has("floaters"):
		return user_data["config"]["floaters"]
	return 0

func set_num_floaters(floaters : int):
	user_data["config"]["floaters"] = floaters

func get_num_attempts() -> int:
	if user_data["config"].has("attempts"):
		return user_data["config"]["attempts"]
	return 0

func set_num_attempts(attempts : int):
	user_data["config"]["attempts"] = attempts

func get_energy() -> float:
	if user_data["config"].has("energy"):
		return user_data["config"]["energy"]
	return 0.0

func set_energy(energy : float):
	user_data["config"]["energy"] = energy


func reset_game_data():
	user_data = default_user_data

## Some game logic helpers	
	
var rocks = [ preload("res://scenes/rocks/Rock0.tscn"),
			preload("res://scenes/rocks/Rock1.tscn"),
			preload("res://scenes/rocks/Rock2.tscn"),
			preload("res://scenes/rocks/Rock3.tscn"),
			preload("res://scenes/rocks/Rock4.tscn"),
]

var floater = preload("res://scenes/floater/floater.tscn")

func spawn_rocks(parentObject : Node2D, numRocks : int, bounds : Rect2):
	
	for i in range(numRocks):
		var rand_x = 0
		var rand_y = 0
		var rand_rock = randi() % len(rocks)
		var new_rock = rocks[rand_rock].instance()
		
		while Vector2(rand_x, rand_y).length_squared() < 50.0:
			rand_x = rand_range(bounds.position.x, bounds.end.x)
			rand_y = rand_range(bounds.position.y, bounds.end.y)
			
		new_rock.position = Vector2(rand_x, rand_y)	
		new_rock.scale = Vector2(0.2,0.2)
		parentObject.add_child(new_rock)
		
func spawn_floaters(parentObject : Node2D, numFloaters : int, bounds : Rect2):
	for i in range(numFloaters):
		var rand_x = rand_range(bounds.position.x, bounds.end.x)
		var rand_y = rand_range(bounds.position.y, bounds.end.y)
		var new_floater = floater.instance()
		new_floater.position = Vector2(rand_x, rand_y)	
		parentObject.add_child(new_floater)
		

func restart_level(parentObject : Node2D, bounds : Rect2):
		
		var level = get_level()
		bounds = bounds.grow(bounds.size.x * BOUNDS_EXTENDERS[level])

		# Take into account eventual previous deaths
		var floaters = FLOATERS[level]
		if get_num_floaters() > floaters:
			floaters = get_num_floaters()
		else:
			set_num_floaters(floaters)
			
		spawn_floaters(parentObject, floaters, bounds )
		spawn_rocks(parentObject, ROCKS[level], bounds)
		set_energy(100.0)
		EventManager.emit_signal("energy_changed")
		EventManager.emit_signal("floater_num_changed")
	
func on_floater_collected():
	var f = get_num_floaters()
	if f > 1:
		set_num_floaters(f-1)
		set_energy(get_energy() + ENERGY_BONUS[get_level()])
		EventManager.emit_signal("energy_changed")
		EventManager.emit_signal("floater_num_changed")
	else:
		var level = get_level() + 1
		if (level > MAX_LEVELS):
			# TBD...
			EventManager.emit_signal("game_complete")
			get_tree().change_scene("res://scenes/finale/finale.tscn")
			
		else:
			set_level(level)	
			EventManager.emit_signal("round_complete")

func on_round_complete():
	GameData.set_num_attempts(0)
	
func round_restart():
	GameData.set_num_attempts(GameData.get_num_attempts()+1)
	GameData.set_num_floaters(GameData.get_num_floaters()+1)
	EventManager.emit_signal("floater_num_changed")
	EventManager.emit_signal("restart_level")
	

func draw_energy(delta : float):
	var energy = get_energy()
	energy = clamp(energy - ENERGY_DRAW, 0, 100.0)
	if energy == 0.0:
		EventManager.emit_signal("energy_exhausted")
	else:
		set_energy(energy)
		EventManager.emit_signal("energy_changed")
	
