# Documentation

## Options

| Option | Description | Default |
| --- | --- | --- |
| `encryption_key` | At-rest encryption key for stored secrets (API keys, MFA, SMTP, OIDC). Leave blank to let Trek auto-generate and persist one. Generate manually with `openssl rand -hex 32` if you want to set it explicitly. | *(auto)* |
| `timezone` | Timezone for logs, reminders, and cron jobs, e.g. `Europe/Berlin`. | `UTC` |
| `log_level` | `info` for concise logs, `debug` for verbose. | `info` |
| `admin_email` | Email for the first admin account, created on first boot. No effect once a user exists. | `admin@trek.local` |
| `admin_password` | Password for the first admin account. Leave blank for a random password (printed to the add-on log). | *(random)* |
| `app_url` | Public base URL of this instance, e.g. `https://trek.example.com`. Required if `oidc_enabled` is on, and used as the base for email notification links. | *(none)* |
| `allowed_origins` | Comma-separated origins for CORS and email links. | *(same-origin)* |
| `oidc_enabled` | Turn on SSO via an OIDC provider (Google, Apple, Authentik, Keycloak, etc). | `false` |
| `oidc_issuer` | OIDC provider URL. Required if `oidc_enabled` is on. | *(none)* |
| `oidc_client_id` | OIDC client ID. | *(none)* |
| `oidc_client_secret` | OIDC client secret. | *(none)* |

## Storage

All persistent data — the SQLite database, uploaded files, and logs — lives
under this add-on's storage area. Back it up like any other add-on: **Settings
→ System → Backups**, or via Trek's own in-app backup/restore under the
Admin panel.

## Reverse proxy / HTTPS

Trek uses WebSockets for real-time sync. If you're putting this behind
Nginx Proxy Manager (or another reverse proxy) rather than exposing port
3000 directly, make sure WebSocket upgrades are proxied on `/ws`, and set
`app_url` to the externally-visible HTTPS URL.

## Updating

Bump `TREK_VERSION` in the add-on's `Dockerfile` and `version` in
`config.yaml` together when a new [Trek release](https://github.com/liketrek/TREK/releases)
comes out, then rebuild. Your data is untouched by updates.

## Known limitations

- Multi-arch support is limited to `amd64` and `aarch64` — Trek's server
  build depends on `better-sqlite3`, a native module, and the upstream image
  isn't confirmed to publish `armv7` builds. Check the
  [Docker Hub tags](https://hub.docker.com/r/mauriceboe/trek/tags) if you're
  on 32-bit ARM.
- This add-on does not use Ingress (embedding TREK inside the HA sidebar
  frame). Trek's WebSocket-heavy client wasn't built with an ingress path
  prefix in mind, so it's exposed on its own port instead. It's reachable at
  `http://<home-assistant-ip>:3000` (or whatever port you map it to).
