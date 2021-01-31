extends CanvasLayer


var lateral_thrusters = preload("res://scenes/particles/thruster_r.tres")
var back_thrusters = preload("res://scenes/particles/thruster_back.tres")
var player_explosion = preload("res://scenes/particles/player_explosion.tres")
var player_aim = preload("res://scenes/particles/turret_aim.tres")

var particle_materials = [ lateral_thrusters, back_thrusters, player_explosion, player_aim]


func _ready():
	
	for material in particle_materials:
		var p_instance = Particles2D.new()
		p_instance.set_process_material(material)
		p_instance.set_one_shot(true)
		p_instance.set_modulate(Color(1,1,1,0))
		p_instance.set_emitting(true)
		self.add_child(p_instance)
		
