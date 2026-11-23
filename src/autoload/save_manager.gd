extends Node
## Sauvegarde locale persistante (Autoload "SaveManager").
## Écrit uniquement dans user:// (jamais res://), au format JSON, de façon
## atomique (fichier temporaire puis renommage).

const SAVE_PATH: String = "user://save.json"
const SAVE_VERSION: int = 1

## Données en mémoire. Les autres systèmes lisent/écrivent via l'API ci-dessous.
var data: Dictionary = {}


func _ready() -> void:
	load_game()


func default_data() -> Dictionary:
	return {
		"version": SAVE_VERSION,
		"levels": {},
		"settings": {"music_volume": 0.8, "sfx_volume": 1.0, "vibration": true},
		"achievements": [],
	}


func load_game(path: String = SAVE_PATH) -> void:
	data = default_data()
	if not FileAccess.file_exists(path):
		return
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning(
			"SaveManager: lecture impossible (%s)" % error_string(FileAccess.get_open_error())
		)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		data.merge(parsed as Dictionary, true)
	else:
		push_warning("SaveManager: sauvegarde corrompue, valeurs par défaut utilisées.")
	Events.save_loaded.emit()


func save_game(path: String = SAVE_PATH) -> bool:
	var tmp_path: String = path + ".tmp"
	var file: FileAccess = FileAccess.open(tmp_path, FileAccess.WRITE)
	if file == null:
		push_error(
			"SaveManager: écriture impossible (%s)" % error_string(FileAccess.get_open_error())
		)
		return false
	file.store_string(JSON.stringify(data))
	file.close()
	var err: Error = DirAccess.rename_absolute(tmp_path, path)
	if err != OK:
		push_error("SaveManager: renommage impossible (%s)" % error_string(err))
		return false
	return true


## Conserve le meilleur score et le meilleur nombre d'étoiles par niveau.
func record_level_result(level_id: StringName, score: int, stars: int) -> void:
	var levels: Dictionary = data["levels"]
	var key: String = String(level_id)
	var previous: Dictionary = levels.get(key, {"best_score": 0, "stars": 0})
	levels[key] = {
		"best_score": maxi(int(previous["best_score"]), score),
		"stars": maxi(int(previous["stars"]), stars),
	}


func get_level_stars(level_id: StringName) -> int:
	var levels: Dictionary = data["levels"]
	var entry: Dictionary = levels.get(String(level_id), {})
	return int(entry.get("stars", 0))


func get_level_best_score(level_id: StringName) -> int:
	var levels: Dictionary = data["levels"]
	var entry: Dictionary = levels.get(String(level_id), {})
	return int(entry.get("best_score", 0))
