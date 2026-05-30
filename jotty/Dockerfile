# ============================================================
# Jotty - Home Assistant Add-on
# Wraps the official Jotty image with HA add-on scaffolding
# ============================================================
ARG BUILD_FROM=ghcr.io/hassio-addons/base:latest
FROM ${BUILD_FROM}

# Use the official Jotty image as a source for its application files
# We copy everything out of it so we can run inside the HA base image
# (which provides bashio, s6-overlay, etc.)
FROM ghcr.io/fccview/jotty:latest AS jotty_source

# ── Final image ──────────────────────────────────────────────────────────────
FROM ghcr.io/hassio-addons/base:latest

# Install Node.js (same major version Jotty uses — 20.x)
RUN apk add --no-cache nodejs npm

# Copy the built Jotty application from the official image
COPY --from=jotty_source /app /app

# Copy our HA entrypoint
COPY run.sh /
RUN chmod a+x /run.sh

# Jotty listens on port 3000
EXPOSE 3000

CMD ["/run.sh"]
