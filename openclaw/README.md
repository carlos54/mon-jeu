# Équipe OpenClaw : installation

## Agents

| id | Rôle | Écrit dans | Ne fait jamais |
|---|---|---|---|
| `producer` | Orchestre, seul contact humain | rien | coder, merger, tagger |
| `analyst` | Spec + critères d'acceptation | `docs/specs/` | coder |
| `architect` | ADR, conventions | `docs/adr/` | coder |
| `qa` | Tests d'abord (rouge) | `tests/` | toucher `src/` |
| `dev` | Code (vert + refactor) | `src/`, `assets/`, `data/` | toucher `tests/` |
| `release` | Pipeline, notes de version | `.github/`, `fastlane/`, `ci/` | publier |

## Installation

```bash
./openclaw/install.sh git@github.com:VOTRE-ORG/mon-jeu.git
openclaw doctor
openclaw agents list --bindings
```

Le script ne remplace jamais une config existante : si `~/.openclaw/openclaw.json` existe,
le bloc d'équipe est déposé dans `~/.openclaw/openclaw.mon-jeu.json5` pour fusion manuelle.
Chaque agent reçoit son propre clone du dépôt (`~/.openclaw/workspace-<id>/repo`) et une
identité Git `<id>-agent@agents.local`.

## Sécurité : où sont les vraies garanties

`tools.allow/deny` et `sandbox` dans `openclaw.json` sont des garde-fous **souples** (un agent
avec `exec` peut contourner une interdiction d'écriture). Les garanties **dures** sont côté GitHub :

1. **Un compte ou token fine-grained par agent**, limité à ce dépôt. Seul `release` reçoit la
   permission « Workflows : write » (GitHub la exige pour modifier `.github/workflows`).
   Aucun agent n'a le droit de pousser sur `main` ni de créer un tag.
2. **Protection de `main`** : PR obligatoire, checks requis (`role-guard`, `quality`,
   `android-debug`), relecture des CODEOWNERS, pas de push direct, pas de force-push.
3. **`ci/scripts/path_guard.sh`** : refuse une PR si un commit d'un agent touche un chemin
   hors de son rôle.
4. **Environnement `production`** avec reviewers obligatoires : aucun déploiement sans humain.
5. **Secrets** uniquement dans les environnements GitHub, jamais accessibles aux agents.

## Prérequis du sandbox
Avec `sandbox.mode: "all"`, les outils des agents s'exécutent dans le sandbox : il doit contenir
`git`, `gh`, Python (gdtoolkit) et le binaire Godot de la version figée dans `ci/versions.env`.
Si ce n'est pas le cas, adaptez le mode de sandbox des agents `qa`, `dev`, `release` selon la doc
OpenClaw « agent sandboxing ».

## Point de vigilance
La config a été écrite d'après la documentation publique (clés `agents.entries`, `sandbox`,
`tools.allow/deny`, `tools.agentToAgent`, `subagents.allowAgents`). Je n'ai pas pu la tester contre
votre installation : `openclaw doctor` fait foi. Les clés de modèle par agent et de profondeur de
sous-agents sont volontairement laissées de côté (à régler selon votre version).

## Persistance du savoir-faire (skills)

`openclaw/prompts/CAPITALISATION.md` est copié dans chaque workspace et référencé par chaque
`AGENTS.md`. Source de vérité : `openclaw/agents/<rôle>/skills/` dans Git.
Cycle : l'agent **propose** (PR `kb/<slug>`) → relecture humaine (CODEOWNERS) → merge →
`install.sh` redéploie. `ci/scripts/path_guard.sh` n'autorise chaque agent à écrire que dans
ses propres skills. Plugin `skill-workshop` : désactivé par défaut (`plugins.entries.skill-workshop`),
à activer si vous voulez des propositions automatiques relues avant application.
