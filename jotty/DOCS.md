# Jotty Add-on Documentation

**Jotty** ([jotty.page](https://jotty.page)) is a lightweight, self-hosted app for managing your personal checklists and notes. It uses file-based storage — no database required — and supports rich text notes, Kanban boards, PGP encryption, SSO via OIDC, and a full REST API.

This add-on pulls the official `ghcr.io/fccview/jotty:latest` image directly and wires it into Home Assistant with persistent, backup-safe storage and sidebar ingress.

---

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Click the **⋮ menu** (top right) → **Repositories**.
3. Add the URL of your custom repository.
4. Find **Jotty** in the store and click **Install**.

---

## First Start

1. Optionally review the configuration options below — defaults work fine for most users.
2. Click **Start**.
3. Click **Open Web UI** or use the **Jotty** sidebar panel.
4. On your first visit you'll be redirected to `/auth/setup` to create your admin account.

---

## Data Storage

Jotty data is stored in the add-on's private `/data` directory, which Home Assistant maps to its own managed storage location:

```
/data/
├── data/
│   ├── checklists/     ← all checklists (.md files)
│   ├── notes/          ← all notes (.md files)
│   ├── users/          ← users.json, sessions.json
│   ├── sharing/        ← shared-items.json
│   └── encryption/     ← PGP keys per user
├── config/             ← Jotty config overrides
└── cache/              ← Next.js build cache
```

> ✅ **`/data` is automatically included in standard Home Assistant backups.** Just use HA's built-in backup feature (Settings → System → Backups) and all Jotty data is covered — no extra configuration needed.

---

## Configuration Options

Options are set in the add-on's **Configuration** tab and passed directly to Jotty as environment variables.

| Option | Default | Description |
|---|---|---|
| `puid` | `1000` | User ID the container runs as. Match your host system user if needed. |
| `pgid` | `1000` | Group ID the container runs as. |
| `node_env` | `production` | Node.js environment mode. Leave as `production`. |
| `stop_check_updates` | `false` | Set to `true` to disable Jotty's built-in update check. |
| `serve_public_images` | `true` | Allow public image serving. |
| `serve_public_files` | `true` | Allow public file serving. |
| `app_url` | _(empty)_ | Your externally accessible URL (e.g. `https://jotty.yourdomain.com`). Required for SSO callback URLs and correct absolute links when accessed outside HA ingress. |
| `sso_mode` | _(empty)_ | Set to `oidc` to enable Single Sign-On. |
| `oidc_issuer` | _(empty)_ | Your OIDC provider issuer URL. |
| `oidc_client_id` | _(empty)_ | OIDC client ID. |
| `oidc_client_secret` | _(empty)_ | OIDC client secret. |
| `sso_fallback_local` | `true` | Allow local username/password login as a fallback when SSO is enabled. |

---

## Single Sign-On (SSO / OIDC)

Jotty supports any OIDC provider — Authentik, Authelia, Keycloak, Auth0, Google, etc. To enable, set these options in the Configuration tab:

| Option | Value |
|---|---|
| `sso_mode` | `oidc` |
| `oidc_issuer` | your provider's issuer URL |
| `oidc_client_id` | your client ID |
| `oidc_client_secret` | your client secret |
| `app_url` | your public Jotty URL |
| `sso_fallback_local` | `true` to keep local login as a fallback |

See the [upstream SSO docs](https://github.com/fccview/jotty/blob/main/howto/SSO.md) for provider-specific setup guides.

---

## Ingress

This add-on supports **Home Assistant Ingress**, appearing as a native **Jotty** panel in your sidebar with no port forwarding required.

If you also want direct external access (e.g. via a reverse proxy), port **1122** is mapped to Jotty's internal port 3000 and can be enabled under **Network** in the add-on settings.

---

## Reverse Proxy

If you expose Jotty externally via a reverse proxy, set `app_url` to your public URL. Example Nginx snippet:

```nginx
location / {
    proxy_pass http://homeassistant:1122;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

---

## Updating Jotty

Since this add-on uses `ghcr.io/fccview/jotty:latest`, updating is a two-step process:

1. Click **Restart** in the add-on panel — HA will pull the latest image automatically if it has been updated upstream.
2. When a new add-on version is released in this repository, you'll see an **Update** button in the Add-on Store.

Jotty runs any required data migrations automatically on first launch after an update.

---

## Troubleshooting

**The web UI is blank or slow on first load:**
Next.js warms up on first start — wait 15–20 seconds and refresh. Check the add-on log if it persists.

**Permission errors in the log:**
Adjust `puid` and `pgid` in the configuration to match your system's user ID (find it with `id -u` on Linux).

**Forgot admin password / need to change super admin:**
See the [upstream docs](https://github.com/fccview/jotty/blob/main/howto/SSO.md) for the `update-super-admin.sh` script.

---

## Links

- **Jotty upstream repo:** https://github.com/fccview/jotty
- **Jotty docs & demo:** https://jotty.page
- **Jotty Discord:** https://discord.gg/invite/mMuk2WzVZu
