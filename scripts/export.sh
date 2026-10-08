#!/usr/bin/env bash
# Snapshot ~/.pi/agent config into ./agent. Secrets are never copied.
set -euo pipefail
SRC="${PI_AGENT_DIR:-$HOME/.pi/agent}"
DST="$(cd "$(dirname "$0")/.." && pwd)/agent"

rm -rf "$DST" && mkdir -p "$DST"

for f in settings.json pi-fff.json subscription-usage-prefs.json AGENTS.md SYSTEM.md keybindings.json; do
  [ -f "$SRC/$f" ] && cp "$SRC/$f" "$DST/$f"
done

# Local package paths only exist on this machine: rewrite to git:<origin> when possible.
if [ -f "$DST/settings.json" ]; then
  tmp="$(mktemp)"
  jq -c '.packages // [] | .[] | (if type=="string" then . else .source end)' "$DST/settings.json" -r |
  while read -r src; do
    case "$src" in /*|~*) ;; *) continue ;; esac
    url="$(git -C "$src" remote get-url origin 2>/dev/null || true)"
    if [ -z "$url" ]; then echo "warn: local package $src has no git origin, left as-is" >&2; continue; fi
    url="${url#https://}"; url="${url#git@}"; url="${url/://}"; url="${url%.git}"
    jq --arg old "$src" --arg new "git:$url" '.packages |= map(
      if . == $old then $new elif type=="object" and .source == $old then .source = $new else . end)' \
      "$DST/settings.json" > "$tmp" && mv "$tmp" "$DST/settings.json"
  done
fi

# models.json: replace literal apiKeys with an env var reference ($<PROVIDER>_API_KEY).
# ponytail: keys already written as "$ENV_VAR" or "!command" are kept.
if [ -f "$SRC/models.json" ]; then
  jq '.providers |= with_entries(
        if (.value.apiKey // "" | test("^(\\$.*|!.*)?$")) then .
        else .value.apiKey = ("$" + (.key | ascii_upcase | gsub("[^A-Z0-9]"; "_")) + "_API_KEY") end)' \
    "$SRC/models.json" > "$DST/models.json"
fi

# Skills: dereference symlinks so the repo is self-contained.
[ -d "$SRC/skills" ] && cp -rL "$SRC/skills" "$DST/skills"

echo "exported to $DST"
