# Plan de test : <slug>

**Spec :** docs/specs/<slug>.md
**Auteur :** qa-agent

## Couverture des critères d'acceptation

| AC | Niveau | Test(s) | Statut |
|---|---|---|---|
| AC-01 | unit | `test_ac01_…` (tests/unit/test_<x>.gd) | rouge |
| AC-02 | integration | `test_ac02_…` (tests/integration/test_<y>.gd) | rouge |
| AC-03 | MANUEL | procédure dans la spec | à faire par l'humain |

## Cas limites ajoutés
- Sauvegarde absente / corrompue
- Pause puis reprise, perte de focus, rotation d'écran
- Valeurs extrêmes (score 0, score maximal)

## Performance
- Mesure(s) : <FPS, mémoire, temps de chargement> ; seuil : <valeur> ; comment : <outil>.

## Risques
- …
