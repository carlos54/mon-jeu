## Feature / slug
<!-- ex: feat/level-select — lien vers docs/specs/<slug>.md -->

## Critères d'acceptation couverts
<!-- AC-01 ✅ test_ac01_... | AC-02 ✅ ... -->

## Checklist (TDD)
- [ ] Les tests ont été écrits AVANT le code (commits `test(...)` antérieurs aux commits `feat(...)`)
- [ ] CI verte (lint, tests, export Android debug)
- [ ] Aucun test affaibli ou supprimé pour passer
- [ ] Perf mobile vérifiée (pas d'allocation en boucle de jeu, pools utilisés)
- [ ] Aucune écriture dans `res://`, aucun secret dans le dépôt
