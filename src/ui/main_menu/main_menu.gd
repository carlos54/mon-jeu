extends Control
## Menu principal.

@onready var _play_button: Button = %PlayButton
@onready var _quit_button: Button = %QuitButton


func _ready() -> void:
	_play_button.pressed.connect(_on_play_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)
	# iOS interdit un bouton "Quitter" (revue App Store) ; inutile sur le Web.
	_quit_button.visible = OS.get_name() not in ["iOS", "Web"]


func _on_play_pressed() -> void:
	if GameManager.change_state(GameManager.State.LEVEL_SELECT):
		SceneManager.change_scene("res://src/ui/level_select/level_select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
