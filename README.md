<p align="center">
  <img src="assets/banner.svg" alt="pi-capsule: Your Pi setup, packed for every machine." width="100%">
</p>

# pi-capsule

A portable capsule for my [Pi Coding Agent](https://pi.dev) setup. One script snapshots `~/.pi/agent` into this repo; one script unpacks it on a fresh machine. Secrets stay home.

- **Settings** — theme, default provider/model, thinking level, compaction overrides, package list.
- **Providers** — custom `models.json` providers, with literal API keys swapped for `$ENV_VAR` references.
- **Skills** — every skill under `~/.pi/agent/skills`, symlinks dereferenced so the repo is self-contained.
- **Extension prefs** — `pi-fff.json`, `subscription-usage-prefs.json`, plus `AGENTS.md` / `SYSTEM.md` / `keybindings.json` when present.

## How it works

```text
~/.pi/agent ──export.sh──▶ agent/ ──git push──▶ GitHub
                                                  │
new machine ◀──restore.sh── agent/ ◀──git clone───┘
```

| Step | What happens |
| --- | --- |
| Local packages | `/home/dev/pi-pulse` becomes `git:github.com/zhugez/pi-pulse` (read from the repo's `origin`) |
| API keys | `"apiKey": "sk-…"` becomes `"apiKey": "$MACMINI_CODEX_API_KEY"`; existing `$VAR` / `!command` values are kept |
| Restore | files already in `~/.pi/agent` are moved to `*.bak` before being replaced |
| First launch | Pi installs any missing `npm:` / `git:` packages from `settings.json` on startup |

## Backup

```bash
./scripts/export.sh
git add -A && git commit -m "sync pi config" && git push
```

## Restore

```bash
git clone https://github.com/zhugez/pi-capsule && cd pi-capsule
./scripts/restore.sh                 # prints every env var it needs
export MACMINI_CODEX_API_KEY=...
pi
```

Then sign in to OAuth providers:

```text
/login antigravity
```

Requires `bash`, `jq` and `git`. Set `PI_AGENT_DIR` to target a directory other than `~/.pi/agent`.

## Security and privacy

These files are **never** exported:

- `auth.json` — provider OAuth/API credentials
- `antigravity-accounts.json` — linked Google accounts and refresh tokens
- `sessions/`, `run-history.jsonl`, caches, installed packages

`export.sh` rewrites literal keys, but review `git diff` before pushing. Keep this repo **private**: `settings.json` and `models.json` still reveal hostnames and model IDs.

## Credits

Banner layout follows [pi-pulse](https://github.com/zhugez/pi-pulse). Illustration generated with Gemini via [`pi-antigravity`](https://github.com/Rahularya01/pi-antigravity).

## License

MIT
