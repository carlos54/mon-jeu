class_name AchievementData
extends Resource
## Succès / défis secondaires (un fichier .tres par succès dans data/achievements/).

@export var id: StringName = &""
@export var title: String = ""
@export_multiline var description: String = ""
@export var target_value: int = 1
