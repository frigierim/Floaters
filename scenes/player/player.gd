extends Node2D

# Welcome to the festival of the magic numbers!
var MAX_FORWARD_SPEED : float = 0.1
var MIN_FORWARD_SPEED : float = 0.005
var FORWARD_THRUST_SPEED : float = 0.04
var LATERAL_THRUST_SPEED : float = 50.0
var FORWARD_THRUST_DECAY : float = 0.02
var TURRET_SPEED : float = 120.0

# Polar coords
var _rotation: float
var _speed : float
var _turret_rotating : bool 
var _offset : Vector2
var _turret_rotation : float
var _shooting : bool
var _hook_base_position : Vector2
var _exploded : bool = false

onready var ThrusterR = get_node("rocket/ThrustersR")
onready var ThrusterL = get_node("rocket/ThrustersL")
onready var ThrusterB = get_node("rocket/ThrustersBack")
onready var turret = get_node("rocket/turret")
onready var aim_particles = get_node("rocket/turret/aim")
onready var hook = get_node("rocket/turret/hook")
onready var hook_anim = get_node("rocket/turret/hook_anim")
onready var body = get_node("ship_area")
onready var hook_body = get_node("rocket/turret/hook/hook_area")
onready var explosion = get_node("explosion")
onready var rocket = get_node("rocket")

func _ready():
	rocket.visible = true
	_turret_rotating = false
	_shooting = false
	_speed = 0.0
	_hook_base_position = hook.position
	# Align the Y axis correctly
	_rotation = deg2rad(-90.0)
	aim_particles.emitting = false
	EventManager.connect("rock_hit", self, "on_rock_hit")
	EventManager.connect("floater_hit", self, "on_floater_hit")
	EventManager.connect("energy_exhausted", self, "on_energy_exhausted")
	
func _process(delta):
	
	if not _exploded:
		
		if Input.is_action_pressed("thrust_b"):
			# enable back thruster
			ThrusterB.emitting = true
			_speed += FORWARD_THRUST_SPEED * delta
		else:
			# disable back thruster	
			ThrusterB.emitting = false
			_speed -= FORWARD_THRUST_DECAY * delta
			
		if Input.is_action_pressed("switch"):
			#switch object
			pass
		
		if Input.is_action_pressed("operate") and not _shooting:
			#Rotate turret
			_turret_rotating = true
			aim_particles.visible = true
			aim_particles.emitting = true
			_turret_rotation += deg2rad(TURRET_SPEED * delta)
			turret.rotate(deg2rad(TURRET_SPEED * delta))
		else:
			if _turret_rotating:
				aim_particles.emitting = false
				aim_particles.visible = false
				_turret_rotating = false
				# Shoot
				AudioManager.play_sound(AudioManager.SOUNDS.SND_HOOK)
				hook_anim.play("shoot")
				_shooting = true
				
				
		if Input.is_action_pressed("thrust_r"):
			ThrusterR.emitting = true
			_rotation += deg2rad(LATERAL_THRUST_SPEED * delta)
			rotate(deg2rad(LATERAL_THRUST_SPEED * delta))
		else:
			ThrusterR.emitting = false
					
		if Input.is_action_pressed("thrust_l"):
			_rotation -= deg2rad(LATERAL_THRUST_SPEED * delta)
			rotate(-deg2rad(LATERAL_THRUST_SPEED * delta)) 
			ThrusterL.emitting = true
		else:
			ThrusterL.emitting = false
	
	else:
		# Slow down after explosion...
		_speed -= FORWARD_THRUST_DECAY * delta

	
	if ThrusterB.emitting || ThrusterL.emitting || ThrusterR.emitting:
		AudioManager.play_sound(AudioManager.SOUNDS.SND_THRUSTER)
	else:
		AudioManager.stop_sound(AudioManager.SOUNDS.SND_THRUSTER)
		
	# never really stop in space
	_speed = clamp(_speed, MIN_FORWARD_SPEED, MAX_FORWARD_SPEED)
	
	# recalc speed in cartesian coords		
	var polar = polar2cartesian(_speed, _rotation)
	var newSpeed : Vector2 = Vector2(polar.x, -polar.y)
	EventManager.emit_signal("changed_speed", newSpeed)
	
	_offset += newSpeed
	EventManager.emit_signal("changed_position", _offset)

func _on_hook_anim_complete():
	_shooting = false

func is_alive():
	return not _exploded
	
func on_rock_hit(id : int) :
	if id == body.get_instance_id() and not _exploded:
		# Boom
		AudioManager.play_sound(AudioManager.SOUNDS.SND_EXPLOSION)
		AudioManager.stop_sound(AudioManager.SOUNDS.SND_THRUSTER)
		AudioManager.stop_sound(AudioManager.SOUNDS.SND_HOOK)
		_exploded = true
		_shooting = false
		_turret_rotating = false
		rocket.visible = false
		explosion.emitting = true
		EventManager.emit_signal("game_over")

func on_energy_exhausted():
		_exploded = true
		_shooting = false
		_turret_rotating = false
		rocket.visible = false
		EventManager.emit_signal("game_over")
	
	
func on_floater_hit(id : int, floater: Object) :
	if id == body.get_instance_id() and not _exploded:
		#splat floater
		floater.bump()
		
	elif id == hook_body.get_instance_id():
		AudioManager.play_sound(AudioManager.SOUNDS.SND_COLLECTED)
		EventManager.emit_signal("floater_collected")
		floater.queue_free()

