#!/usr/bin/env bash
# Copy ./agent into ~/.pi/agent and ./home into ~, install CLI tools.
# Existing files are backed up to <file>.bak first.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/agent"
DST="${PI_AGENT_DIR:-$HOME/.pi/agent}"
mkdir -p "$DST"

for f in "$SRC"/*; do
  name="$(basename "$f")"
  [ -e "$DST/$name" ] && { rm -rf "$DST/$name.bak"; mv "$DST/$name" "$DST/$name.bak"; }
  cp -r "$f" "$DST/$name"
done
chmod 600 "$DST/models.json" 2>/dev/null || true

# Dotfiles of companion tools, mirrored from ~ (see DOTFILES in export.sh).
if [ -d "$ROOT/home" ]; then
  (cd "$ROOT/home" && find . -type f) | while read -r rel; do
    mkdir -p "$(dirname "$HOME/$rel")"
    [ -e "$HOME/$rel" ] && cp "$HOME/$rel" "$HOME/$rel.bak"
    cp "$ROOT/home/$rel" "$HOME/$rel"
  done
fi

# Companion CLIs: <command> <official install script>. Skipped when already on PATH.
while read -r cmd url; do
  command -v "$cmd" >/dev/null || curl -fsSL "$url" | sh
done <<'TOOLS'
no-mistakes https://raw.githubusercontent.com/kunchenguid/no-mistakes/main/docs/install.sh
rtk https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh
treehouse https://kunchenguid.github.io/treehouse/install.sh
TOOLS
export PATH="$HOME/.local/bin:$PATH"

# Hook rtk into Pi (writes ~/.pi/agent/extensions/rtk.ts).
command -v rtk >/dev/null && rtk init -g --agent pi >/dev/null

echo "restored to $DST"
jq -r '.providers // {} | to_entries[] | .value.apiKey | select(startswith("$")) | ltrimstr("$") | ltrimstr("{") | rtrimstr("}")' "$SRC/models.json" 2>/dev/null |
  sed 's/^/set env var: /'
echo "then run: pi   (missing npm:/git: packages install on first startup), then /login for OAuth providers"
echo "per repo: no-mistakes init   (adds the gate remote + /no-mistakes skill)"
