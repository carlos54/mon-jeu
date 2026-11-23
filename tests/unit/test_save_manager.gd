extends GdUnitTestSuite
## Tests de la persistance (toujours dans user://, jamais res://).

const SaveManagerScript: GDScript = preload("res://src/autoload/save_manager.gd")
const TMP_PATH: String = "user://test_save.json"


func after_test() -> void:
	for path: String in [TMP_PATH, TMP_PATH + ".tmp"]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)


func _new_manager() -> Node:
	var manager: Node = auto_free(SaveManagerScript.new())
	manager.data = manager.default_data()
	return manager


func test_aller_retour_de_la_sauvegarde() -> void:
	var writer: Node = _new_manager()
	writer.record_level_result(&"level_01", 1200, 2)
	assert_bool(writer.save_game(TMP_PATH)).is_true()

	var reader: Node = _new_manager()
	reader.load_game(TMP_PATH)
	assert_int(reader.get_level_stars(&"level_01")).is_equal(2)
	assert_int(reader.get_level_best_score(&"level_01")).is_equal(1200)


func test_le_meilleur_resultat_est_conserve() -> void:
	var manager: Node = _new_manager()
	manager.record_level_result(&"level_01", 500, 3)
	manager.record_level_result(&"level_01", 100, 1)
	assert_int(manager.get_level_best_score(&"level_01")).is_equal(500)
	assert_int(manager.get_level_stars(&"level_01")).is_equal(3)


func test_fichier_absent_donne_les_valeurs_par_defaut() -> void:
	var manager: Node = _new_manager()
	manager.load_game("user://n_existe_pas.json")
	assert_int(manager.get_level_stars(&"level_99")).is_equal(0)


func test_fichier_corrompu_donne_les_valeurs_par_defaut() -> void:
	var file: FileAccess = FileAccess.open(TMP_PATH, FileAccess.WRITE)
	file.store_string("{ pas du json")
	file.close()
	var manager: Node = _new_manager()
	manager.load_game(TMP_PATH)
	assert_int(manager.get_level_stars(&"level_01")).is_equal(0)
