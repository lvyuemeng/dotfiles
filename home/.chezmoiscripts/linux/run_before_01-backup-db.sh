#!/bin/bash
# Backup openlist database
set -euo pipefail

chezmoiRoot="{{ .chezmoi.sourceDir }}"
templPath="$chezmoiRoot/.chezmoitemplates/openlist/data.db.age"

dbPath="/opt/openlist/data/data.db"
stateDir="$HOME/.cache/openlist"
hashFile="$stateDir/data.db.sha256"

[[ -f "$dbPath" ]] || {
  echo "[INFO] openlist db not found, skip backup"
  exit 0
}

mkdir -p "$stateDir"
currentHash="$(sha256sum "$dbPath" | awk '{print $1}')"

if [[ -f "$hashFile" ]] && [[ "$(cat "$hashFile")" == "$currentHash" ]]; then
  echo "[INFO] openlist db unchanged"
  exit 0
fi

chezmoi encrypt "$tempSql" > "$templPath"
echo -n "$currentHash" > "$hashFile"
echo "[OK] openlist db backed up"