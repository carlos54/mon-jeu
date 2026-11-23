extends Control
## Sélection de niveau : ÉCRAN PROVISOIRE (à implémenter via le workflow TDD).

@onready var _back_button: Button = %BackButton


func _ready() -> void:
	_back_button.pressed.connect(_on_back_pressed)


func _on_back_pressed() -> void:
	if GameManager.change_state(GameManager.State.MENU):
		SceneManager.change_scene("res://src/ui/main_menu/main_menu.tscn")
