extends Node
## Bus de signaux global (Autoload "Events").
## Découple les systèmes : l'émetteur ne connaît pas les récepteurs.
## Aucun état ici, uniquement des signaux.

signal game_state_changed(previous: int, current: int)
signal level_started(level_id: StringName)
signal level_completed(level_id: StringName, score: int, stars: int)
signal level_failed(level_id: StringName)
signal score_changed(score: int)
signal settings_changed
signal save_loaded
