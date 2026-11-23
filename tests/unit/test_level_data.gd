extends GdUnitTestSuite
## Tests du calcul d'étoiles.


func test_aucune_etoile_sous_le_premier_seuil() -> void:
	var level: LevelData = LevelData.new()
	assert_int(level.stars_for_score(99)).is_equal(0)


func test_etoiles_selon_les_seuils() -> void:
	var level: LevelData = LevelData.new()
	assert_int(level.stars_for_score(100)).is_equal(1)
	assert_int(level.stars_for_score(250)).is_equal(2)
	assert_int(level.stars_for_score(10000)).is_equal(3)
