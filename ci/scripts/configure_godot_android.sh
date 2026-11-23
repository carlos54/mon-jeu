#!/usr/bin/env bash
# Configure Godot (headless) pour l'export Android : chemins SDK/JDK et
# keystore de debug. À lancer après setup-java et setup-android.
set -euo pipefail

: "${ANDROID_HOME:?ANDROID_HOME manquant (android-actions/setup-android)}"
: "${JAVA_HOME:?JAVA_HOME manquant (actions/setup-java)}"
: "${GODOT_VERSION:?GODOT_VERSION manquant}"

major_minor="${GODOT_VERSION%.*}"

# Le nom du fichier de réglages dépend de la version de Godot : on écrit les
# deux variantes connues, c'est sans effet de bord.
cfg_dir="${XDG_CONFIG_HOME:-$HOME/.config}/godot"
mkdir -p "$cfg_dir"
for name in "editor_settings-4.tres" "editor_settings-${major_minor}.tres"; do
  cat > "$cfg_dir/$name" <<EOF
[gd_resource type="EditorSettings" format=3]

[resource]
export/android/android_sdk_path = "${ANDROID_HOME}"
export/android/java_sdk_path = "${JAVA_HOME}"
EOF
done

# Keystore de debug jetable (jamais utilisé pour la release).
debug_ks="${RUNNER_TEMP:-/tmp}/debug.keystore"
if [[ ! -f "$debug_ks" ]]; then
  keytool -genkey -v -keystore "$debug_ks" -alias androiddebugkey \
    -storepass android -keypass android -keyalg RSA -keysize 2048 \
    -validity 10000 -dname "CN=Android Debug,O=Android,C=US" >/dev/null 2>&1
fi

if [[ -n "${GITHUB_ENV:-}" ]]; then
  {
    echo "GODOT_ANDROID_KEYSTORE_DEBUG_PATH=${debug_ks}"
    echo "GODOT_ANDROID_KEYSTORE_DEBUG_USER=androiddebugkey"
    echo "GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD=android"
  } >> "$GITHUB_ENV"
fi
echo "Godot configuré pour Android (SDK=${ANDROID_HOME}, JDK=${JAVA_HOME})."
