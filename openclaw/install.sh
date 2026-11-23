#!/usr/bin/env bash
# Installe les workspaces des agents dans ~/.openclaw et clone le dépôt du jeu
# dans le workspace de chaque agent (un clone par agent : pas de collisions).
#
# Usage : openclaw/install.sh <url_du_depot_git> [dossier_openclaw]
# Ne remplace JAMAIS une configuration existante : elle est laissée intacte et
# le bloc d'équipe est déposé à côté pour fusion manuelle.
set -euo pipefail

repo_url="${1:?usage: install.sh <url_du_depot_git> [dossier_openclaw]}"
oc_home="${2:-$HOME/.openclaw}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$oc_home"

# 1) Configuration : jamais d'écrasement.
if [[ -f "$oc_home/openclaw.json" ]]; then
  cp "$here/openclaw.json" "$oc_home/openclaw.mon-jeu.json5"
  echo "Config existante conservée. Bloc d'équipe déposé dans :"
  echo "  $oc_home/openclaw.mon-jeu.json5  (à fusionner dans openclaw.json)"
else
  cp "$here/openclaw.json" "$oc_home/openclaw.json"
  echo "Config installée : $oc_home/openclaw.json"
fi

# 2) Workspaces des agents.
for agent_dir in "$here"/agents/*/; do
  id="$(basename "$agent_dir")"
  ws="$oc_home/workspace-$id"
  mkdir -p "$ws" "$oc_home/agents/$id/agent"
  cp "$agent_dir"/*.md "$ws/"
  cp "$here/prompts/CAPITALISATION.md" "$ws/CAPITALISATION.md"
  if [[ -d "$agent_dir/skills" ]]; then
    mkdir -p "$ws/skills"
    cp -R "$agent_dir/skills/." "$ws/skills/"
  fi
  if [[ ! -d "$ws/repo/.git" ]]; then
    git clone "$repo_url" "$ws/repo"
  fi
  # Identité Git propre à l'agent : exigée par ci/scripts/path_guard.sh.
  git -C "$ws/repo" config user.name "${id}-agent"
  git -C "$ws/repo" config user.email "${id}-agent@agents.local"
  echo "Agent prêt : $id  ($ws)"
done

cat <<'MSG'

Étapes suivantes :
  1. Donnez à CHAQUE agent son propre token GitHub (voir openclaw/README.md).
  2. Vérifiez la config :  openclaw doctor
  3. Listez les agents :   openclaw agents list --bindings
MSG
