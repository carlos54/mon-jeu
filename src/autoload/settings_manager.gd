extends Node
## Préférences utilisateur (Autoload "SettingsManager") : volumes et vibrations.
## Persistées via SaveManager. Émet Events.settings_changed à chaque changement.

var music_volume: float = 0.8
var sfx_volume: float = 1.0
var vibration_enabled: bool = true


func _ready() -> void:
	Events.save_loaded.connect(_load_from_save)
	# SaveManager a déjà chargé (ordre des autoloads) : on lit tout de suite.
	_load_from_save()


func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	_commit()


func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 1.0)
	_commit()


func set_vibration_enabled(enabled: bool) -> void:
	vibration_enabled = enabled
	_commit()


func _load_from_save() -> void:
	var stored: Dictionary = SaveManager.data.get("settings", {})
	music_volume = clampf(float(stored.get("music_volume", 0.8)), 0.0, 1.0)
	sfx_volume = clampf(float(stored.get("sfx_volume", 1.0)), 0.0, 1.0)
	vibration_enabled = bool(stored.get("vibration", true))
	Events.settings_changed.emit()


func _commit() -> void:
	SaveManager.data["settings"] = {
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"vibration": vibration_enabled,
	}
	SaveManager.save_game()
	Events.settings_changed.emit()
