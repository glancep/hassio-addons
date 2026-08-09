# TREK Travel Planner

Self-hosted, real-time collaborative travel planner — trip planning, interactive
maps, budgets/expense splitting, packing lists, and a PWA client. This add-on
wraps the [official TREK image](https://hub.docker.com/r/mauriceboe/trek)
maintained by [liketrek/TREK](https://github.com/liketrek/TREK).

## Updating

This is pinned to a specific Trek version. Until I can get this automated,
the following changes are required to update the HA app upon a new version
of Trek:

1. Monitor [Trek Releases](https://github.com/liketrek/TREK/releases) for updates
2. Update HA app version in [config.yaml](./config.yaml) — the intent is to keep this version
   number matching Trek's versioning.
3. Update the Trek image version in [Dockerfile](./Dockerfile)
4. Add details into [CHANGELOG.md](./CHANGELOG.md) (from [Trek Releases](https://github.com/liketrek/TREK/releases))



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
