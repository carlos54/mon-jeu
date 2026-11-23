# Architecture

## Autoloads (ordre = ordre de dépendance, voir `project.godot`)

| # | Singleton | Rôle | Dépend de |
|---|---|---|---|
| 1 | `Events` | Bus de signaux global, sans état | n/a |
| 2 | `SaveManager` | JSON dans `user://`, écriture atomique | Events |
| 3 | `SettingsManager` | Volumes, vibrations, persistés | Events, SaveManager |
| 4 | `AudioManager` | Bus Master/Music/SFX, pool de lecteurs | Events, SettingsManager |
| 5 | `GameManager` | États BOOT→MENU→LEVEL_SELECT→PLAYING⇄PAUSED→RESULTS | Events, SaveManager |
| 6 | `SceneManager` | Fondu + chargement threadé des scènes | n/a |

## Découpage
- `src/core/` : briques génériques (machine à états, zone sûre, vibrations, pools).
- `src/entities/` : scènes autonomes (joueur, ennemis, collectibles, projectiles).
- `src/levels/` : scènes de niveaux (`level_base.tscn` + variantes) ; données dans `data/levels/`.
- `src/ui/` : un dossier par écran ; racine = `SafeAreaContainer`.
- `src/resources/` : classes `Resource` de données (`LevelData`, `AchievementData`).

## Règles
1. Les entités ne connaissent pas les autoloads : elles émettent des signaux, `GameManager`/UI écoutent.
2. Les nœuds de menu/pause utilisent `process_mode = ALWAYS` (le jeu met `get_tree().paused` en PAUSED).
3. Aucune écriture dans `res://` ; tout dans `user://` via `SaveManager`.
4. Rendu : Compatibility (GL), textures ETC2/ASTC, stretch `canvas_items` + `expand`.

## Écrans à venir (tous à construire en TDD)
`level_base`, `player`, `hud` (+ contrôles tactiles), `pause`, `results`, `settings`.
