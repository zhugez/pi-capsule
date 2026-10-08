#!/usr/bin/env bash
# Copy ./agent into ~/.pi/agent. Existing files are backed up to <file>.bak first.
set -euo pipefail
SRC="$(cd "$(dirname "$0")/.." && pwd)/agent"
DST="${PI_AGENT_DIR:-$HOME/.pi/agent}"
mkdir -p "$DST"

for f in "$SRC"/*; do
  name="$(basename "$f")"
  [ -e "$DST/$name" ] && { rm -rf "$DST/$name.bak"; mv "$DST/$name" "$DST/$name.bak"; }
  cp -r "$f" "$DST/$name"
done
chmod 600 "$DST/models.json" 2>/dev/null || true

# no-mistakes: install CLI if missing, then restore its global config.
if ! command -v no-mistakes >/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/kunchenguid/no-mistakes/main/docs/install.sh | sh
fi
NM_SRC="$SRC/../no-mistakes/config.yaml"
if [ -f "$NM_SRC" ]; then
  mkdir -p "$HOME/.no-mistakes"
  [ -e "$HOME/.no-mistakes/config.yaml" ] && cp "$HOME/.no-mistakes/config.yaml" "$HOME/.no-mistakes/config.yaml.bak"
  cp "$NM_SRC" "$HOME/.no-mistakes/config.yaml"
fi

echo "restored to $DST"
jq -r '.providers // {} | to_entries[] | .value.apiKey | select(startswith("$")) | ltrimstr("$") | ltrimstr("{") | rtrimstr("}")' "$SRC/models.json" 2>/dev/null |
  sed 's/^/set env var: /'
echo "then run: pi   (missing npm:/git: packages install on first startup), then /login for OAuth providers"
echo "per repo: no-mistakes init   (adds the gate remote + /no-mistakes skill)"
