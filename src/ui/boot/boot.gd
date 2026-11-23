extends Node
## Scène de démarrage : les autoloads (dont la sauvegarde) sont déjà prêts.
## Passe à l'état MENU puis charge le menu principal.


func _ready() -> void:
	GameManager.change_state(GameManager.State.MENU)
	SceneManager.change_scene("res://src/ui/main_menu/main_menu.tscn")
