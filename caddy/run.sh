#!/bin/sh
set -e

mkdir -p /config

exec caddy run --config /config/Caddyfile --adapter caddyfile
