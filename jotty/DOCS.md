# Jotty Add-on Documentation

**Jotty** ([jotty.page](https://jotty.page)) is a lightweight, self-hosted app for managing your personal checklists and notes. It uses file-based storage — no database required — and supports rich text notes, Kanban boards, PGP encryption, SSO via OIDC, and a full REST API.

---

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Click the **⋮ menu** (top right) → **Repositories**.
3. Add the URL of your custom repository (the folder containing this add-on).
4. Find **Jotty** in the store and click **Install**.

---

## First Start

1. Optionally configure the add-on options (see below) — defaults work fine for most users.
2. Click **Start**.
3. Click **Open Web UI** or use the **Jotty** sidebar panel.
4. On your first visit you'll be redirected to `/auth/setup` to create your admin account.

---

## Data Storage

All Jotty data is stored in the add-on's private `/data` directory:

```
/data/
├── data/
│   ├── checklists/     ← all checklists (.md files)
│   ├── notes/          ← all notes (.md files)
│   ├── users/          ← users.json, sessions.json
│   ├── sharing/        ← shared-items.json
│   └── encryption/     ← PGP keys per user
├── config/             ← Jotty config overrides
└── cache/              ← Next.js build cache (optional)
```

> ✅ **`/data` is automatically included in standard Home Assistant backups.** No extra configuration needed — just use HA's built-in backup feature (Settings → System → Backups) and Jotty data is covered.

---

## Configuration Options

| Option | Default | Description |
|---|---|---|
| `node_env` | `production` | Node.js environment mode. Leave as `production`. |
| `stop_check_updates` | `false` | Set to `true` to disable Jotty's built-in update check. |
| `serve_public_images` | `true` | Allow public image serving. |
| `serve_public_files` | `true` | Allow public file serving. |
| `app_url` | _(empty)_ | Your externally accessible URL (e.g. `https://jotty.yourdomain.com`). Required for SSO callback URLs and correct absolute links. |
| `sso_mode` | _(empty)_ | Set to `oidc` to enable Single Sign-On. |
| `oidc_issuer` | _(empty)_ | Your OIDC provider issuer URL. |
| `oidc_client_id` | _(empty)_ | OIDC client ID. |
| `oidc_client_secret` | _(empty)_ | OIDC client secret. |
| `sso_fallback_local` | `true` | Allow local username/password login as a fallback when SSO is enabled. |

---

## Single Sign-On (SSO / OIDC)

Jotty supports any OIDC provider — Authentik, Authelia, Keycloak, Auth0, Google, etc. To enable:

```yaml
sso_mode: oidc
oidc_issuer: "https://authentik.yourdomain.com/application/o/jotty/"
oidc_client_id: "your-client-id"
oidc_client_secret: "your-client-secret"
app_url: "https://jotty.yourdomain.com"
sso_fallback_local: true
```

See the [upstream SSO docs](https://github.com/fccview/jotty/blob/main/howto/SSO.md) for provider-specific setup guides.

---

## Ingress

This add-on supports **Home Assistant Ingress**, so it appears as a native panel in your sidebar under the name **Jotty** without needing to open a separate port. The ingress URL is auto-detected and passed to Jotty as `APP_URL` unless you set it manually.

If you also want direct external access (e.g. via a reverse proxy), the port **1122** is mapped to internal port 3000 and can be enabled under **Network** in the add-on settings.

---

## Reverse Proxy

If you expose Jotty externally, set `app_url` to your public URL. Example Nginx config snippet:

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

When a new version of Jotty is released on GitHub, update this add-on by bumping the `version` in `config.yaml` and rebuilding. Jotty will automatically run any required data migrations on first launch after an update.

---

## Troubleshooting

**The web UI is blank or shows an error on first load:**
- Wait 10–15 seconds; Next.js warms up on first start.
- Check the add-on log for errors.

**Permission errors in the log:**
- The add-on runs as user `1000:1000`. HA manages the `/data` directory ownership automatically.

**Forgot admin password / need to change super admin:**
- Use the upstream script: see [SSO.md](https://github.com/fccview/jotty/blob/main/howto/SSO.md#changing-super-admin) for the `update-super-admin.sh` instructions.

---

## Links

- **Jotty upstream repo:** https://github.com/fccview/jotty
- **Jotty docs:** https://jotty.page
- **Jotty Discord:** https://discord.gg/invite/mMuk2WzVZu
