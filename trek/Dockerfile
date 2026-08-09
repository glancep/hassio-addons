# Pin to a specific Trek release rather than :latest, so add-on updates are
# deliberate (bump TREK_VERSION + config.yaml version together, not silent).
# Check https://github.com/liketrek/TREK/releases for the current tag.
ARG TREK_VERSION=3.3.0
FROM mauriceboe/trek:${TREK_VERSION}

USER root

# jq is all we need to read HA's /data/options.json — no bashio/s6 required
# since we're not building on an HA base image.
RUN apt-get update && \
    apt-get install -y --no-install-recommends jq && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

# Deliberately NOT overriding ENTRYPOINT — the base image's dumb-init stays
# PID 1 and handles signal forwarding / zombie reaping. We only replace CMD.
CMD ["/run.sh"]
