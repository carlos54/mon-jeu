extends GdUnitTestSuite
## Tests de la machine à états globale.

const GameManagerScript: GDScript = preload("res://src/autoload/game_manager.gd")


func _new_manager() -> Node:
	return auto_free(GameManagerScript.new())


func test_boot_ne_peut_aller_que_vers_menu() -> void:
	var manager: Node = _new_manager()
	assert_bool(manager.can_transition(GameManagerScript.State.MENU)).is_true()
	assert_bool(manager.can_transition(GameManagerScript.State.PLAYING)).is_false()


func test_transition_valide_change_l_etat() -> void:
	var manager: Node = _new_manager()
	assert_bool(manager.change_state(GameManagerScript.State.MENU)).is_true()
	assert_int(manager.state).is_equal(GameManagerScript.State.MENU)


func test_transition_invalide_est_refusee_et_etat_inchange() -> void:
	var manager: Node = _new_manager()
	assert_bool(manager.change_state(GameManagerScript.State.RESULTS)).is_false()
	assert_int(manager.state).is_equal(GameManagerScript.State.BOOT)


func test_start_level_exige_la_selection_de_niveau() -> void:
	var manager: Node = _new_manager()
	manager.change_state(GameManagerScript.State.MENU)
	assert_bool(manager.start_level(&"level_01")).is_false()
	manager.change_state(GameManagerScript.State.LEVEL_SELECT)
	assert_bool(manager.start_level(&"level_01")).is_true()
	assert_int(manager.score).is_equal(0)


func test_add_score_cumule() -> void:
	var manager: Node = _new_manager()
	manager.add_score(10)
	manager.add_score(5)
	assert_int(manager.score).is_equal(15)
