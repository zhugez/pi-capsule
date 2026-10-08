# pi-config

Portable backup of my [Pi Coding Agent](https://pi.dev) config (`~/.pi/agent`), so a new machine is one clone away.

## What's included

| Path | Notes |
| --- | --- |
| `agent/settings.json` | theme, default model, packages, compaction. Local package paths are rewritten to `git:<origin>` |
| `agent/models.json` | custom providers. Literal `apiKey`s become `$<PROVIDER>_API_KEY` |
| `agent/skills/` | all skills, symlinks dereferenced |
| `agent/pi-fff.json`, `agent/subscription-usage-prefs.json` | extension prefs |

**Never exported:** `auth.json`, `antigravity-accounts.json`, sessions, history, caches, installed packages.

## Backup (current machine)

```bash
./scripts/export.sh
git add -A && git commit -m "sync pi config" && git push
```

## Restore (new machine)

```bash
git clone https://github.com/zhugez/pi-config && cd pi-config
./scripts/restore.sh          # existing files are moved to *.bak
export MACMINI_CODEX_API_KEY=...   # the script lists every key it needs
pi                            # missing npm:/git: packages install on first startup
```

Then `/login` for OAuth providers (e.g. `/login antigravity`).

Requires `bash`, `jq`, `git`. Set `PI_AGENT_DIR` to target a different directory.
