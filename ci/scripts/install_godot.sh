#!/usr/bin/env bash
# Installe l'éditeur Godot (et optionnellement les export templates) à la
# version exacte de ci/versions.env. Linux et macOS.
# Usage : ci/scripts/install_godot.sh [true|false]   (installer les templates)
set -euo pipefail

: "${GODOT_VERSION:?GODOT_VERSION manquant (source ci/versions.env)}"
with_templates="${1:-false}"

cache="$HOME/godot-cache"
mkdir -p "$cache" "$HOME/bin"
base="https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable"

case "$(uname -s)" in
  Linux)
    zip_name="Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip"
    bin_rel="Godot_v${GODOT_VERSION}-stable_linux.x86_64"
    tpl_dir="$HOME/.local/share/godot/export_templates/${GODOT_VERSION}.stable"
    ;;
  Darwin)
    zip_name="Godot_v${GODOT_VERSION}-stable_macos.universal.zip"
    bin_rel="Godot.app/Contents/MacOS/Godot"
    tpl_dir="$HOME/Library/Application Support/Godot/export_templates/${GODOT_VERSION}.stable"
    ;;
  *)
    echo "OS non supporté : $(uname -s)" >&2
    exit 1
    ;;
esac

download() {
  local file="$1"
  if [[ ! -s "$cache/$file" ]]; then
    curl -fsSL --retry 3 -o "$cache/$file" "$base/$file"
  fi
}

download "$zip_name"
editor_dir="$cache/editor-${GODOT_VERSION}"
rm -rf "$editor_dir"
mkdir -p "$editor_dir"
unzip -q -o "$cache/$zip_name" -d "$editor_dir"
chmod +x "$editor_dir/$bin_rel"
ln -sf "$editor_dir/$bin_rel" "$HOME/bin/godot"
if [[ -n "${GITHUB_PATH:-}" ]]; then
  echo "$HOME/bin" >> "$GITHUB_PATH"
fi

if [[ "$with_templates" == "true" ]]; then
  tpz="Godot_v${GODOT_VERSION}-stable_export_templates.tpz"
  download "$tpz"
  tmp="$(mktemp -d)"
  unzip -q -o "$cache/$tpz" -d "$tmp"
  rm -rf "$tpl_dir"
  mkdir -p "$tpl_dir"
  cp -R "$tmp/templates/." "$tpl_dir/"
  rm -rf "$tmp"
fi

# Garde-fou : la version réellement exécutée doit être celle attendue.
actual="$("$HOME/bin/godot" --headless --version)"
echo "Godot installé : $actual"
case "$actual" in
  "${GODOT_VERSION}.stable"*) ;;
  *)
    echo "Version inattendue (attendu ${GODOT_VERSION}.stable*)" >&2
    exit 1
    ;;
esac
