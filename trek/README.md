# TREK Travel Planner

Self-hosted, real-time collaborative travel planner — trip planning, interactive
maps, budgets/expense splitting, packing lists, and a PWA client. This add-on
wraps the [official TREK image](https://hub.docker.com/r/mauriceboe/trek)
maintained by [liketrek/TREK](https://github.com/liketrek/TREK).

## Quick start

1. Install the add-on and open its **Configuration** tab.
2. Optionally set `encryption_key` — if left blank, Trek generates and
   persists one on first boot.
3. Optionally set `admin_email` / `admin_password` — if left blank, a random
   admin password is generated and printed to the add-on log on first boot.
4. Start the add-on, open the web UI on port `3000`.

See [DOCS.md](./DOCS.md) for the full options reference.

Your data lives entirely in this add-on's persistent storage (`/data`
internally) — updates never touch it.
