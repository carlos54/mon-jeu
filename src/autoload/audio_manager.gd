extends Node
## Audio (Autoload "AudioManager") : bus dédiés Master / Music / SFX.
## Les volumes viennent de SettingsManager et sont ré-appliqués à chaque changement.

const BUS_MUSIC: StringName = &"Music"
const BUS_SFX: StringName = &"SFX"
const SFX_POLYPHONY: int = 8

var _music_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _next_sfx: int = 0


func _ready() -> void:
	# Doit continuer pendant la pause (musique de menu).
	process_mode = Node.PROCESS_MODE_ALWAYS

	_music_player = AudioStreamPlayer.new()
	_music_player.bus = BUS_MUSIC
	add_child(_music_player)

	# Pool fixe de lecteurs SFX : aucune allocation pendant le jeu.
	for i: int in SFX_POLYPHONY:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.bus = BUS_SFX
		add_child(player)
		_sfx_players.append(player)

	Events.settings_changed.connect(_apply_volumes)
	_apply_volumes()


func play_music(stream: AudioStream) -> void:
	if _music_player.stream == stream and _music_player.playing:
		return
	_music_player.stream = stream
	_music_player.play()


func stop_music() -> void:
	_music_player.stop()


func play_sfx(stream: AudioStream) -> void:
	var player: AudioStreamPlayer = _sfx_players[_next_sfx]
	_next_sfx = (_next_sfx + 1) % SFX_POLYPHONY
	player.stream = stream
	player.play()


func _apply_volumes() -> void:
	_set_bus_volume(BUS_MUSIC, SettingsManager.music_volume)
	_set_bus_volume(BUS_SFX, SettingsManager.sfx_volume)


func _set_bus_volume(bus_name: StringName, linear: float) -> void:
	var index: int = AudioServer.get_bus_index(bus_name)
	if index < 0:
		push_warning(
			"AudioManager: bus introuvable (%s), vérifiez default_bus_layout.tres" % bus_name
		)
		return
	AudioServer.set_bus_volume_db(index, linear_to_db(linear))
	AudioServer.set_bus_mute(index, linear <= 0.0)
