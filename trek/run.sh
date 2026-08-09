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
# storage is mounted at /data instead, so we symlink into place.
#
# NOTE: because this script cd's into /app/server before exec'ing node
# (required so tsconfig-paths/register can find its config), Trek's own
# "data"/"uploads" relative paths resolve against THAT cwd — i.e. actual
# runtime writes land on /app/server/data, not /app/data as upstream's
# standalone deployment docs describe. We link both locations to the same
# backing store so it works regardless of which path Trek resolves.
echo "Setting up persistent storage..."
mkdir -p /data/trek-data /data/trek-uploads
rm -rf /app/data /app/uploads /app/server/data /app/server/uploads
ln -s /data/trek-data /app/data
ln -s /data/trek-uploads /app/uploads
ln -s /data/trek-data /app/server/data
ln -s /data/trek-uploads /app/server/uploads
mkdir -p /data/trek-data/logs /data/trek-uploads/files /data/trek-uploads/covers \
         /data/trek-uploads/avatars /data/trek-uploads/photos

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

# --- Arbitrary user-defined env vars -------------------------------------
# env_vars is a list of {name, value} objects in options.json. Applied
# last, so it can override anything above (including PORT/NODE_ENV) if
# the user deliberately sets one of those names — that's on them.
env_count=$(jq -r '.env_vars | length' "$OPTIONS")
i=0
while [ "$i" -lt "$env_count" ]; do
    var_name=$(jq -r --argjson i "$i" '.env_vars[$i].name' "$OPTIONS")
    var_value=$(jq -r --argjson i "$i" '.env_vars[$i].value // empty' "$OPTIONS")
    if [ -n "$var_name" ]; then
        export "$var_name=$var_value"
    fi
    i=$((i + 1))
done

echo "Starting Trek..."

# --- Hand off to Trek's own startup logic --------------------------------
# Reuses the same preflight check, chown, and privilege-drop pattern as
# the base image's own CMD, just invoked from our wrapper instead.
if [ ! -f /app/server/dist/index.js ]; then
  echo "FATAL: TREK application files missing from image (unexpected — base image issue)."
  exit 1
fi

chown -R node:node /data/trek-data /data/trek-uploads

cd /app/server
exec gosu node node --require tsconfig-paths/register dist/index.js