#!/usr/bin/env sh
set -e

OPTIONS="/data/options.json"

get() { jq -r ".$1 // empty" "$OPTIONS"; }
bool() {
    val=$(jq -r ".$1" "$OPTIONS")
    [ "$val" = "true" ] && echo "yes" || echo "no"
}

# ── Export env vars from HA options ───────────────────────────────────────────
export NODE_ENV=$(get node_env)
export STOP_CHECK_UPDATES=$(bool stop_check_updates)
export SERVE_PUBLIC_IMAGES=$(bool serve_public_images)
export SERVE_PUBLIC_FILES=$(bool serve_public_files)
export SSO_FALLBACK_LOCAL=$(bool sso_fallback_local)

val=$(get app_url);          [ -n "$val" ] && export APP_URL="$val"
val=$(get auth_mode);        [ -n "$val" ] && export AUTH_MODE="$val"
val=$(get oidc_issuer);      [ -n "$val" ] && export OIDC_ISSUER="$val"
val=$(get oidc_client_id);   [ -n "$val" ] && export OIDC_CLIENT_ID="$val"
val=$(get oidc_client_secret); [ -n "$val" ] && export OIDC_CLIENT_SECRET="$val"

# ── Symlink HA /data into Jotty's expected paths ──────────────────────────────
mkdir -p /data/data/users /data/data/checklists /data/data/notes \
         /data/data/sharing /data/data/encryption \
         /data/config /data/cache

# Replace Jotty's default dirs with symlinks into HA's persistent /data
[ -L /app/data ]        || { rm -rf /app/data;        ln -sf /data/data   /app/data; }
[ -L /app/config ]      || { rm -rf /app/config;      ln -sf /data/config /app/config; }
[ -L /app/.next/cache ] || { rm -rf /app/.next/cache; ln -sf /data/cache  /app/.next/cache; }

chown -R 1000:1000 /data/data /data/config /data/cache 2>/dev/null || true

echo "Starting Jotty..."

# Hand off to Jotty's real entrypoint, passing CMD args through
exec /usr/local/bin/docker-entrypoint.sh "$@"
