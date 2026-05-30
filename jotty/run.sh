#!/usr/bin/with-contenv bashio
# ==============================================================================
# Jotty - Home Assistant Add-on
# Starts Jotty with configuration from the HA Add-on options
# ==============================================================================

# ── Data directory setup ──────────────────────────────────────────────────────
# HA maps /share/jotty for persistent storage. We create the expected
# sub-directories that Jotty needs inside that share volume.

# /data is the add-on's private persistent directory, automatically
# included in Home Assistant backups. HA manages it — no map: needed.
DATA_DIR="/data"
mkdir -p \
  "${DATA_DIR}/data/users" \
  "${DATA_DIR}/data/checklists" \
  "${DATA_DIR}/data/notes" \
  "${DATA_DIR}/data/sharing" \
  "${DATA_DIR}/data/encryption" \
  "${DATA_DIR}/config" \
  "${DATA_DIR}/cache"

# ── Read options ─────────────────────────────────────────────────────────────
NODE_ENV=$(bashio::config 'node_env')
STOP_CHECK_UPDATES=$(bashio::config 'stop_check_updates')
SERVE_PUBLIC_IMAGES=$(bashio::config 'serve_public_images')
SERVE_PUBLIC_FILES=$(bashio::config 'serve_public_files')
APP_URL=$(bashio::config 'app_url')
SSO_MODE=$(bashio::config 'sso_mode')
OIDC_ISSUER=$(bashio::config 'oidc_issuer')
OIDC_CLIENT_ID=$(bashio::config 'oidc_client_id')
OIDC_CLIENT_SECRET=$(bashio::config 'oidc_client_secret')
SSO_FALLBACK_LOCAL=$(bashio::config 'sso_fallback_local')

# ── Build environment ─────────────────────────────────────────────────────────
export NODE_ENV="${NODE_ENV:-production}"
export DATA_PATH="${DATA_DIR}/data"
export CONFIG_PATH="${DATA_DIR}/config"
export CACHE_PATH="${DATA_DIR}/cache"

# Boolean → yes/no conversion for Jotty env vars
if bashio::config.true 'serve_public_images'; then
  export SERVE_PUBLIC_IMAGES="yes"
else
  export SERVE_PUBLIC_IMAGES="no"
fi

if bashio::config.true 'serve_public_files'; then
  export SERVE_PUBLIC_FILES="yes"
else
  export SERVE_PUBLIC_FILES="no"
fi

if bashio::config.true 'stop_check_updates'; then
  export STOP_CHECK_UPDATES="yes"
else
  export STOP_CHECK_UPDATES="no"
fi

# ── Optional SSO / OIDC ───────────────────────────────────────────────────────
if bashio::config.has_value 'sso_mode'; then
  export SSO_MODE="${SSO_MODE}"
  bashio::log.info "SSO mode enabled: ${SSO_MODE}"
fi

if bashio::config.has_value 'oidc_issuer'; then
  export OIDC_ISSUER="${OIDC_ISSUER}"
fi

if bashio::config.has_value 'oidc_client_id'; then
  export OIDC_CLIENT_ID="${OIDC_CLIENT_ID}"
fi

if bashio::config.has_value 'oidc_client_secret'; then
  export OIDC_CLIENT_SECRET="${OIDC_CLIENT_SECRET}"
fi

if bashio::config.true 'sso_fallback_local'; then
  export SSO_FALLBACK_LOCAL="yes"
fi

# ── App URL (important for SSO callback URLs) ─────────────────────────────────
if bashio::config.has_value 'app_url'; then
  export APP_URL="${APP_URL}"
  bashio::log.info "App URL set to: ${APP_URL}"
fi

# ── Ingress base path (HA ingress support) ────────────────────────────────────
# HA ingress provides a dynamic path like /api/hassio_ingress/<token>
# Jotty's Next.js app reads NEXTAUTH_URL / APP_URL for absolute redirects.
if bashio::var.true "$(bashio::addon.ingress)"; then
  INGRESS_URL="$(bashio::addon.ingress_url)"
  bashio::log.info "Running behind HA ingress at: ${INGRESS_URL}"
  # Only set APP_URL from ingress if not already specified by user
  if ! bashio::config.has_value 'app_url'; then
    export APP_URL="${INGRESS_URL}"
  fi
fi

# ── Permissions ───────────────────────────────────────────────────────────────
# Jotty expects to run as user 1000:1000
chown -R 1000:1000 "${DATA_DIR}" 2>/dev/null || true

bashio::log.info "Starting Jotty..."
bashio::log.info "  Data:   ${DATA_DIR}/data"
bashio::log.info "  Config: ${DATA_DIR}/config"
bashio::log.info "  Cache:  ${DATA_DIR}/cache"

# ── Launch ────────────────────────────────────────────────────────────────────
# Override the default volume mounts by symlinking into /app paths
# (The official image expects /app/data, /app/config, /app/.next/cache)
ln -sfn "${DATA_DIR}/data"   /app/data   2>/dev/null || true
ln -sfn "${DATA_DIR}/config" /app/config 2>/dev/null || true
ln -sfn "${DATA_DIR}/cache"  /app/.next/cache 2>/dev/null || true

exec s6-setuidgid 1000:1000 node /app/server.js
