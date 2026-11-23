# Mon Jeu : jeu mobile 2D (Godot 4) + équipe d'agents OpenClaw + CI/CD

Dépôt complet : projet Godot (squelette), équipe d'agents OpenClaw, pipeline GitHub Actions
(Android `.aab`/`.apk`, iOS via Xcode + fastlane), développement piloté par les tests (gdUnit4).

## Contenu

```
.
├── project.godot  export_presets.cfg  default_bus_layout.tres
├── src/            autoloads, core (state machine, safe area), ressources, UI de départ
├── tests/          suites gdUnit4 (unit/, integration/)
├── data/ assets/   données (.tres) et ressources
├── docs/           WORKFLOW, templates de spec/test, ARCHITECTURE, DoD
├── openclaw/       openclaw.json + 6 agents (AGENTS.md, SOUL.md) + install.sh
├── ci/             versions.env (versions figées) + scripts (install, export, garde-fou)
├── fastlane/       lanes Android (Play) et iOS (match, TestFlight, App Store)
└── .github/        workflows quality / ci / release, actions composites, CODEOWNERS
```

## Démarrage rapide

1. Créez le dépôt GitHub, poussez ce contenu, puis ouvrez le projet dans Godot (4.7.x) :
   l'éditeur réécrit légèrement `project.godot`, relisez le diff.
2. Éditez `ci/versions.env` : vérifiez `GODOT_VERSION`, figez `GDUNIT4_REF`, alignez les versions
   Android (SDK/NDK) sur la doc « Exporting for Android » de votre version de Godot.
3. Exécutez `bundle lock` et versionnez `Gemfile.lock`.
4. Configurez GitHub (section suivante), puis installez l'équipe : `openclaw/install.sh <url-du-depot>`.

## Configuration GitHub

**Protection de `main`** : PR obligatoire, checks requis `role-guard`, `quality / lint`,
`quality / test`, `android-debug` ; relecture CODEOWNERS ; pas de force-push.

**Environnements** : `staging` (sans reviewers) et `production` (**reviewers obligatoires**).

**Variables** (Settings → Environments → Variables) : `ANDROID_PACKAGE`, `IOS_BUNDLE_ID`, `APPLE_TEAM_ID`.

**Secrets** (à placer dans l'environnement `staging` sauf mention) :

| Secret | Contenu |
|---|---|
| `ANDROID_KEYSTORE_B64` | keystore de release encodé en base64 |
| `ANDROID_KEYSTORE_ALIAS` / `ANDROID_KEYSTORE_PASSWORD` | alias et mot de passe (clé = keystore) |
| `PLAY_JSON_KEY` | JSON du compte de service Google Play (staging **et** production) |
| `ASC_KEY_ID` / `ASC_ISSUER_ID` / `ASC_KEY_P8_B64` | clé API App Store Connect (staging **et** production) |
| `MATCH_GIT_URL` / `MATCH_PASSWORD` / `MATCH_GIT_BASIC_AUTHORIZATION` | dépôt privé de certificats iOS (match) |

## Cycle d'une feature (TDD)

`spec validée` → `QA : tests rouges` → `Dev : tests verts + refactor` → `PR` → `CI verte + relecture`
→ `merge` → `tag vX.Y.Z (humain)` → `build + bêta` → `approbation production (humain)`.
Détails : `docs/WORKFLOW.md`.

## Ce qui est vérifié, et ce qui ne l'est pas

Validé ici : syntaxe YAML des workflows, JSON5 de la config OpenClaw, scripts shell (`bash -n`),
et GDScript analysé par `gdtoolkit` (lint/format).
**Non exécuté** (pas de Godot, de runner GitHub ni de compte store dans cet environnement) :
les exports réels, les tests gdUnit4, fastlane, et le chargement par OpenClaw. Attendez-vous à
quelques ajustements au premier run, notamment :
- versions Android SDK/NDK selon votre version de Godot (`ci/versions.env`) ;
- options d'export iOS (icônes, profils) et lane `ios beta` ;
- version/ref de gdUnit4 et nom du fichier de réglages de l'éditeur (`configure_godot_android.sh`) ;
- premier import headless (`--import`), qui peut demander deux passages.
