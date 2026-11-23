#!/usr/bin/env bash
# Export Android headless.
# Usage : ci/scripts/export_android.sh debug|release
#   debug   -> build/android/game-debug.apk
#   release -> build/android/game-release.apk + game-release.aab
# Release : GODOT_ANDROID_KEYSTORE_RELEASE_{PATH,USER,PASSWORD} requis.
set -uo pipefail

mode="${1:?debug|release}"
mkdir -p build/android

# Import initial (cache des ressources) ; code de retour non fiable au 1er passage.
godot --headless --path . --import || true

export_one() {
  local flag="$1" preset="$2" out="$3"
  godot --headless --path . "$flag" "$preset" "$out"
  # Godot peut sortir en 0 malgré une erreur d'export : on vérifie le fichier.
  if [[ ! -s "$out" ]]; then
    echo "Export échoué : $out absent ou vide" >&2
    exit 1
  fi
}

case "$mode" in
  debug)
    export_one --export-debug "Android APK" build/android/game-debug.apk
    ;;
  release)
    : "${GODOT_ANDROID_KEYSTORE_RELEASE_PATH:?keystore release manquant}"
    : "${GODOT_ANDROID_KEYSTORE_RELEASE_USER:?alias manquant}"
    : "${GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD:?mot de passe manquant}"
    export_one --export-release "Android APK" build/android/game-release.apk
    export_one --export-release "Android AAB" build/android/game-release.aab
    ;;
  *)
    echo "Mode inconnu : $mode" >&2
    exit 2
    ;;
esac

ls -lh build/android
