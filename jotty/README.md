# Jotty – Home Assistant Add-on

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fyour-username%2Fhassio-addons)

This repository provides a [Home Assistant Add-on](https://www.home-assistant.io/addons/) for **[Jotty](https://jotty.page)** — a lightweight, self-hosted app for managing personal checklists and notes.

## Features

- 📋 Checklists with drag & drop, Kanban boards, and time tracking
- 📝 Rich text notes with full Markdown support
- 🔒 PGP encryption for sensitive notes
- 👥 Multi-user with admin panel
- 🔑 SSO via any OIDC provider (Authentik, Keycloak, Auth0, etc.)
- 🗄️ File-based storage — no database needed
- 📱 PWA support for mobile home screen install
- 🔌 REST API for automation and integrations

## Installation

1. Click the badge above **or** manually add this repository URL in HA:
   - **Settings → Add-ons → Add-on Store → ⋮ → Repositories**
   - Add: `https://github.com/your-username/hassio-addons`
2. Find **Jotty** and click **Install**
3. Start the add-on and open the Web UI

All data is stored persistently in `/share/jotty/` on your Home Assistant instance.

## Documentation

See [`jotty/DOCS.md`](jotty/DOCS.md) for full configuration reference.

## Upstream

This add-on wraps the official [fccview/jotty](https://github.com/fccview/jotty) Docker image.
License: [AGPL-3.0](https://github.com/fccview/jotty/blob/main/LICENSE)
