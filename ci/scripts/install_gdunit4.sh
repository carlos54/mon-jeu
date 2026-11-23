#!/usr/bin/env bash
# Installe l'addon gdUnit4 dans addons/ (non versionné) à la référence
# GDUNIT4_REF de ci/versions.env.
set -euo pipefail

: "${GDUNIT4_REF:?GDUNIT4_REF manquant (source ci/versions.env)}"

if [[ -d addons/gdUnit4 ]]; then
  echo "addons/gdUnit4 déjà présent, rien à faire."
  exit 0
fi

tmp="$(mktemp -d)"
git clone --depth 1 --branch "$GDUNIT4_REF" https://github.com/MikeSchulze/gdUnit4.git "$tmp/gdunit4"
mkdir -p addons
cp -R "$tmp/gdunit4/addons/gdUnit4" addons/gdUnit4
rm -rf "$tmp"
echo "gdUnit4 ($GDUNIT4_REF) installé."
