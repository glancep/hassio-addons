#!/bin/sh
set -e

OPTIONS=/data/options.json

json_get() {
  jq -r --arg k "$1" '.[$k] // empty' "$OPTIONS"
}

set_env_if_present() {
  var_name="$1"
  value="$2"
  if [ -n "$value" ]; then
    export "$var_name=$value"
  fi
}

# --- Persistent storage ------------------------------------------------
# Trek's image refuses to start if a volume is mounted directly at /app
# (it hides the baked-in node_modules/dist). HA's persistent add-on
# storage is mounted at /data instead, so we symlink the two subpaths
# Trek actually reads/writes (data + uploads) into place.
echo "Setting up persistent storage..."
mkdir -p /data/trek-data /data/trek-uploads
rm -rf /app/data /app/uploads
ln -s /data/trek-data /app/data
ln -s /data/trek-uploads /app/uploads
mkdir -p /app/data/logs /app/uploads/files /app/uploads/covers \
         /app/uploads/avatars /app/uploads/photos

# --- Translate HA add-on options into Trek's env vars -------------------
echo "Restoring configuration from add-on options..."
set_env_if_present ENCRYPTION_KEY   "$(json_get encryption_key)"
set_env_if_present TZ               "$(json_get timezone)"
set_env_if_present LOG_LEVEL        "$(json_get log_level)"
set_env_if_present ADMIN_EMAIL      "$(json_get admin_email)"
set_env_if_present ADMIN_PASSWORD   "$(json_get admin_password)"
set_env_if_present APP_URL          "$(json_get app_url)"
set_env_if_present ALLOWED_ORIGINS  "$(json_get allowed_origins)"

if [ "$(json_get oidc_enabled)" = "true" ]; then
  set_env_if_present OIDC_ISSUER        "$(json_get oidc_issuer)"
  set_env_if_present OIDC_CLIENT_ID     "$(json_get oidc_client_id)"
  set_env_if_present OIDC_CLIENT_SECRET "$(json_get oidc_client_secret)"
fi

export PORT=3000
export NODE_ENV=production

echo "Starting Trek..."

# --- Hand off to Trek's own startup logic --------------------------------
# Reuses the same preflight check, chown, and privilege-drop pattern as
# the base image's own CMD, just invoked from our wrapper instead.
if [ ! -f /app/server/dist/index.js ]; then
  echo "FATAL: TREK application files missing from image (unexpected — base image issue)."
  exit 1
fi

# --- Temporary diagnostics — remove once this is confirmed working ------
echo "DEBUG whoami: $(whoami)"
echo "DEBUG id: $(id)"
echo "DEBUG /app/data -> $(readlink -f /app/data)"
echo "DEBUG ls -la /app/data:"
ls -la /app/data
echo "DEBUG ls -la $(readlink -f /app/data):"
ls -la "$(readlink -f /app/data)"
# --------------------------------------------------------------------------

# NOTE: chown errors are no longer swallowed — if this line fails, the
# script will now exit loudly instead of hiding it, which is what we want
# while debugging.
chown -R node:node /app/data /app/uploads

cd /app/server
exec gosu node node --require tsconfig-paths/register dist/index.js