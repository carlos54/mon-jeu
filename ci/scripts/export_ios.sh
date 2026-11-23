#!/usr/bin/env bash
# Export du projet Xcode iOS (headless). La compilation et la signature sont
# faites ensuite par fastlane (lane ios beta). Runner macOS requis.
set -uo pipefail

: "${IOS_PROJECT_NAME:?IOS_PROJECT_NAME manquant (ci/versions.env)}"

mkdir -p build/ios
godot --headless --path . --import || true

out="build/ios/${IOS_PROJECT_NAME}.xcodeproj"
godot --headless --path . --export-release "iOS" "$out"

if [[ ! -d "$out" ]]; then
  echo "Export iOS échoué : $out absent" >&2
  exit 1
fi
ls -la build/ios
