extends Node2D

var _speed : Vector2 = Vector2(0.0, 0.0)
var FLOATER_SPEED_MULTIPLIER : float = 20000.0
var BUMP_DECAY : float = 0.01
var MIN_BUMP_SPEED : float = 0.1
var RANDOM_BUMP_AMOUNT : float = 0.01
var MAX_ROTATION_SPEED : float = .05

onready var area = get_node("Area2D")
var _bumping : bool = false
var _bump_speed : Vector2 = Vector2(0,0)
var _rotation_speed : float

# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.connect("changed_speed", self, "on_changed_speed")
	area.connect("area_entered", self, "_on_area_entered")
	_rotation_speed = -0.5 * randf() * MAX_ROTATION_SPEED
	
func on_changed_speed(newSpeed : Vector2):
	if not _bumping:
		_speed = newSpeed * FLOATER_SPEED_MULTIPLIER * Vector2(-1,1)	
	else:
		_speed = newSpeed * FLOATER_SPEED_MULTIPLIER * Vector2(-1,1) + _bump_speed
		_bump_speed -= Vector2(BUMP_DECAY, BUMP_DECAY)
		if _bump_speed.length() < MIN_BUMP_SPEED:
			_bumping = false
		
func _process(delta):
	self.translate(_speed * delta)
	self.rotate(_rotation_speed)

func _on_area_entered(area : Area2D):
	EventManager.emit_signal("floater_hit", area.get_instance_id(), self)

func bump():
	_bump_speed = Vector2(rand_range(-RANDOM_BUMP_AMOUNT, RANDOM_BUMP_AMOUNT), rand_range(-RANDOM_BUMP_AMOUNT,RANDOM_BUMP_AMOUNT)) * FLOATER_SPEED_MULTIPLIER
	_bumping = true
