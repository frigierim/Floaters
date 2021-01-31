extends Node2D

var _speed : Vector2 = Vector2(0.0, 0.0)
var ROCK_SPEED_MULTIPLIER : float = 20000.0
var MAX_ROTATION_SPEED : float = .05
var _rotation_speed : float

onready var area = get_node("Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.connect("changed_speed", self, "on_changed_speed")
	area.connect("area_entered", self, "_on_area_entered")
	_rotation_speed = -0.5 * randf() * MAX_ROTATION_SPEED
	
func on_changed_speed(newSpeed : Vector2):
	if newSpeed.x != 0:
		_speed = newSpeed * ROCK_SPEED_MULTIPLIER * Vector2(-1,1)
	
func _process(delta):
	self.translate(_speed * delta)
	self.rotate(_rotation_speed)
	
func _on_area_entered(area : Area2D):
	EventManager.emit_signal("rock_hit", area.get_instance_id())
