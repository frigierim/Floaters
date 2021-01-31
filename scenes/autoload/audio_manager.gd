extends Node

const MIN_AUDIO_VOLUME : float = 0.02
const MAX_AUDIO_VOLUME : float = 1.0
# We save the normalized value in the game data, from 0.0 to 1.0

#var _bg_music = preload("res://assets/audio/POL-happy-tribe-short.ogg")

onready var _music_player = AudioStreamPlayer.new()
onready var _sfx_players = [
							AudioStreamPlayer.new(),
							AudioStreamPlayer.new(),
							AudioStreamPlayer.new(),
							AudioStreamPlayer.new()
]


enum SOUNDS { SND_COLLECTED, SND_EXPLOSION, SND_HOOK, SND_THRUSTER }

var sound_names : Array = [ "res://assets/sounds/collected.wav",
							"res://assets/sounds/explosion.wav",
							"res://assets/sounds/hook.wav",
							"res://assets/sounds/thruster.wav"  ]
var sounds : Array = []		

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	EventManager.connect("change_volume", self, "on_change_volume")
	self.add_child(_music_player);
	
	for i in range(len(_sfx_players)):
		self.add_child(_sfx_players[i]);
	
	#_music_player.stream = _bg_music

	var vol = GameData.get_music_volume()
	
	for i in sound_names:
		sounds.append(load(i))
		var idx = len(sounds) - 1
		_sfx_players[idx].stream = sounds[idx]
		
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
	
	for i in range(len(_sfx_players)):
		_sfx_players[i].volume_db = linear2db(volume)
		
	GameData.set_music_volume(volume)

func play_sound(index : int):
	
	if index < sounds.size() and ! _sfx_players[index].is_playing():
		_sfx_players[index].play()
	
func stop_sound(index : int):
	
	if index < sounds.size() and _sfx_players[index].is_playing():
		_sfx_players[index].stop()
