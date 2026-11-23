#!/usr/bin/env bash
# Lance la suite gdUnit4 en headless. Code de sortie 0 = OK.
# gdUnit4 renvoie 101 quand tout passe mais avec des avertissements : toléré.
set -uo pipefail

# L'import initial construit le cache des classes (class_name). Il peut
# renvoyer un code non nul au premier passage : on le lance deux fois.
godot --headless --path . --import || true
godot --headless --path . --import || true

mkdir -p reports
godot --headless --path . \
  -s -d res://addons/gdUnit4/bin/GdUnitCmdTool.gd \
  --ignoreHeadlessMode \
  --add res://tests \
  --continue \
  -rd reports
rc=$?

if [[ $rc -eq 0 || $rc -eq 101 ]]; then
  exit 0
fi
echo "Tests en échec (code $rc)" >&2
exit "$rc"
