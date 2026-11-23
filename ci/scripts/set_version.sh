#!/usr/bin/env bash
# Injecte version et identifiants dans export_presets.cfg (copie de travail CI).
# Usage : ci/scripts/set_version.sh <version_name> <version_code>
# Variables optionnelles : ANDROID_PACKAGE, IOS_BUNDLE_ID, APPLE_TEAM_ID
set -euo pipefail

name="${1:?version name (ex: 1.2.0)}"
code="${2:?version code (entier croissant)}"
file="export_presets.cfg"

if [[ ! "$name" =~ ^[0-9A-Za-z.+-]+$ ]]; then
  echo "Nom de version invalide : $name" >&2
  exit 1
fi
if [[ ! "$code" =~ ^[0-9]+$ ]]; then
  echo "Code de version invalide : $code" >&2
  exit 1
fi

# iOS exige un x.y.z numérique : on retire un éventuel suffixe (-rc1, +build).
ios_short="${name%%[-+]*}"

export V_NAME="$name" V_CODE="$code" V_IOS_SHORT="$ios_short"
perl -pi -e '
  s{^version/code=.*}{version/code=$ENV{V_CODE}};
  s{^version/name=.*}{version/name="$ENV{V_NAME}"};
  s{^application/short_version=.*}{application/short_version="$ENV{V_IOS_SHORT}"};
  s{^application/version=.*}{application/version="$ENV{V_CODE}"};
  s{^package/unique_name=.*}{package/unique_name="$ENV{ANDROID_PACKAGE}"} if $ENV{ANDROID_PACKAGE};
  s{^application/bundle_identifier=.*}{application/bundle_identifier="$ENV{IOS_BUNDLE_ID}"} if $ENV{IOS_BUNDLE_ID};
  s{^application/app_store_team_id=.*}{application/app_store_team_id="$ENV{APPLE_TEAM_ID}"} if $ENV{APPLE_TEAM_ID};
' "$file"

if [[ -n "${GITHUB_ENV:-}" ]]; then
  {
    echo "VERSION_NAME=${name}"
    echo "VERSION_CODE=${code}"
  } >> "$GITHUB_ENV"
fi
echo "Version ${name} (${code}) injectée dans ${file}."
