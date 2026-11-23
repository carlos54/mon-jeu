#!/usr/bin/env bash
# Garde-fou de séparation des rôles.
# Chaque agent commite avec l'email "<role>-agent@agents.local". Pour chaque
# commit d'une PR, on vérifie que les fichiers touchés sont dans le périmètre
# de ce rôle. Les commits humains (autre email) ne sont pas restreints.
#
# Usage : ci/scripts/path_guard.sh <base_ref> [head_ref]
set -euo pipefail

base="${1:?usage: path_guard.sh <base_ref> [head_ref]}"
head="${2:-HEAD}"

declare -A RULES=(
  [analyst-agent]="docs/specs/ docs/GDD.md openclaw/agents/analyst/skills/"
  [architect-agent]="docs/adr/ docs/ARCHITECTURE.md openclaw/agents/architect/skills/"
  [qa-agent]="tests/ docs/test-plans/ openclaw/agents/qa/skills/"
  [dev-agent]="src/ assets/ data/ project.godot default_bus_layout.tres icon.svg openclaw/agents/dev/skills/"
  [release-agent]=".github/ fastlane/ ci/ export_presets.cfg Gemfile Gemfile.lock docs/release-notes/ openclaw/agents/release/skills/"
)

fail=0
while read -r sha email; do
  role="${email%%@*}"
  allowed="${RULES[$role]:-}"
  [[ -z "$allowed" ]] && continue   # commit humain ou rôle inconnu : non restreint

  while read -r file; do
    [[ -z "$file" ]] && continue
    ok=0
    for pattern in $allowed; do
      if [[ "$pattern" == */ ]]; then
        [[ "$file" == "$pattern"* ]] && ok=1
      else
        [[ "$file" == "$pattern" ]] && ok=1
      fi
    done
    if (( ok == 0 )); then
      echo "::error file=${file}::${role} n'a pas le droit de modifier ${file} (commit ${sha:0:8})"
      fail=1
    fi
  done < <(git diff-tree --no-commit-id --name-only -r "$sha")
done < <(git log --format='%H %ae' "${base}..${head}")

if (( fail )); then
  echo "Violation du périmètre des rôles. Voir docs/WORKFLOW.md." >&2
  exit 1
fi
echo "Périmètres des rôles respectés."
