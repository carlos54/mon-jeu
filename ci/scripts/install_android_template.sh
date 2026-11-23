#!/usr/bin/env bash
# Installe le template Gradle Android (android/build) depuis les export
# templates de la version figée, comme le fait l'éditeur
# ("Projet > Installer le modèle de build Android"). Garantit que
# android/.build_version == version de Godot, sinon l'export est refusé.
set -euo pipefail

: "${GODOT_VERSION:?GODOT_VERSION manquant}"

tpl_zip="$HOME/.local/share/godot/export_templates/${GODOT_VERSION}.stable/android_source.zip"
expected="${GODOT_VERSION}.stable"

if [[ -f android/.build_version ]] && grep -q "$GODOT_VERSION" android/.build_version \
   && [[ -f android/build/build.gradle ]]; then
  echo "Template Android déjà aligné sur ${expected}."
  exit 0
fi

if [[ ! -f "$tpl_zip" ]]; then
  echo "android_source.zip introuvable : installez les export templates (${tpl_zip})." >&2
  exit 1
fi

rm -rf android/build
mkdir -p android/build
unzip -q -o "$tpl_zip" -d android/build
printf '%s' "$expected" > android/.build_version
touch android/build/.gdignore
chmod +x android/build/gradlew 2>/dev/null || true
echo "Template Android installé pour ${expected}."
