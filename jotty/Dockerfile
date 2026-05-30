# ============================================================
# Jotty - Home Assistant Add-on
# Uses the official multi-arch Jotty image directly.
# HA supervisor injects bashio and s6-overlay at build time
# via the build_from base, but since Jotty's image already
# has everything it needs, we just wrap it with our run.sh.
# ============================================================
FROM ghcr.io/fccview/jotty:latest

# Install bashio for reading HA add-on options in run.sh
RUN apk add --no-cache bash curl \
 && curl -fsSL https://raw.githubusercontent.com/hassio-addons/bashio/master/lib/bashio.sh \
      -o /usr/lib/bashio.sh \
 && chmod +x /usr/lib/bashio.sh

# Copy our HA entrypoint
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 3000

CMD ["/run.sh"]
