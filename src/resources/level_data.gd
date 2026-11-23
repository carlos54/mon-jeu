class_name LevelData
extends Resource
## Description d'un niveau (données pures, sans logique de jeu).
## Un fichier .tres par niveau dans data/levels/.

@export var id: StringName = &""
@export var display_name: String = ""
@export_file("*.tscn") var scene_path: String = ""
## Scores minimums pour obtenir 1, 2, 3... étoiles (ordre croissant).
@export var star_thresholds: PackedInt32Array = PackedInt32Array([100, 250, 500])


func stars_for_score(score: int) -> int:
	var stars: int = 0
	for threshold: int in star_thresholds:
		if score >= threshold:
			stars += 1
	return stars
