# Workflow : équipe d'agents + TDD + CI/CD

## Vue d'ensemble

```
Humain ─▶ Producer ─▶ Analyste ─▶ [PORTE 1 : humain valide la spec]
                          │
                          ▼
                     Architecte (ADR si besoin)
                          │
                          ▼
   QA : tests ROUGES ─▶ Dev : tests VERTS + refactor ─▶ PR vers main
                                                          │
                              CI : role-guard · lint · tests · export Android debug
                                                          │
                              [PORTE 2 : CI verte + relecture humaine] ─▶ merge
                                                          │
   Release (pipeline) prépare notes ─▶ HUMAIN pousse le tag vX.Y.Z
                                                          │
          CI/CD : build Android/iOS ─▶ piste interne / TestFlight
                                                          │
                      [PORTE 3 : approbation humaine, environnement "production"]
                                                          │
                          Google Play (déploiement progressif) · App Store (revue)
```

## Règles de branches et de commits

| Élément | Règle |
|---|---|
| Branche de feature | `feat/<slug>` (une seule, partagée séquentiellement par Analyste → QA → Dev) |
| Branche pipeline | `ci/<sujet>` (Release uniquement) |
| Préfixes de commit | `spec(slug):` `test(slug):` `feat(slug):` `fix(slug):` `ci(sujet):` |
| Identité Git | `<role>-agent@agents.local` (le garde-fou s'en sert) |
| Merge | Humain uniquement, après CI verte |
| Tag de release | Humain uniquement |

## Pourquoi la CI est rouge sur `feat/<slug>` au début
C'est le cycle rouge du TDD : le QA pousse des tests qui échouent. Le Dev les rend verts.
Seul `main` doit toujours être vert (protection de branche).

## Périmètre d'écriture par rôle (appliqué par `ci/scripts/path_guard.sh`)

| Rôle | Chemins autorisés |
|---|---|
| analyst | `docs/specs/`, `docs/GDD.md` |
| architect | `docs/adr/`, `docs/ARCHITECTURE.md` |
| qa | `tests/`, `docs/test-plans/` |
| dev | `src/`, `assets/`, `data/`, `project.godot`, `default_bus_layout.tres`, `icon.svg` |
| release | `.github/`, `fastlane/`, `ci/`, `export_presets.cfg`, `Gemfile*`, `docs/release-notes/` |

Chaque rôle peut en plus écrire dans **ses propres skills** : `openclaw/agents/<rôle>/skills/`
(branche `kb/<slug>`, relecture humaine). Voir `openclaw/prompts/CAPITALISATION.md`.

## Les trois portes humaines
1. **Spec validée** avant tout test ou code.
2. **PR relue** et CI verte avant merge.
3. **Tag poussé** puis **approbation de l'environnement `production`** avant publication.
