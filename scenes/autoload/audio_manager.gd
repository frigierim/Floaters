extends Node

const MIN_AUDIO_VOLUME : float = 0.02
const MAX_AUDIO_VOLUME : float = 1.0
# We save the normalized value in the game data, from 0.0 to 1.0

#var _bg_music = preload("res://assets/audio/POL-happy-tribe-short.ogg")

onready var _music_player = AudioStreamPlayer.new()
onready var _sfx_player = AudioStreamPlayer.new()


enum SOUNDS { SND_ELEPHANT, SND_AMANI, SND_LION }

var sound_names : Array = [ "res://assets/audio/elephant.ogg",
							"res://assets/audio/amani.ogg",
							"res://assets/audio/lion.ogg"  ]
var sounds : Array = []		

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	EventManager.connect("change_volume", self, "on_change_volume")
	self.add_child(_music_player);
	self.add_child(_sfx_player);
	
	#_music_player.stream = _bg_music

	var vol = GameData.get_music_volume()
	
	for i in sound_names:
		sounds.append(load(i))

	on_change_volume(vol)

func on_change_volume(volume : float):
	if volume < MIN_AUDIO_VOLUME:
		_music_player.stop()
	else:
		if volume > MAX_AUDIO_VOLUME:
			volume = MAX_AUDIO_VOLUME
		if ! _music_player.playing:
			_music_player.play()

	_music_player.volume_db = linear2db(volume)
	_sfx_player.volume_db = linear2db(volume)
	GameData.set_music_volume(volume)

func play_sound(index : int):
	
	if index < sounds.size():
		_sfx_player.stop()
		_sfx_player.stream = sounds[index]
		_sfx_player.play()
	
