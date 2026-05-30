ARG BUILD_FROM=ghcr.io/fccview/jotty:latest
FROM ${BUILD_FROM}

RUN apk add --no-cache jq

COPY jotty-start.sh /jotty-start.sh
RUN chmod +x /jotty-start.sh

ENTRYPOINT ["/jotty-start.sh"]
CMD ["node", "server.js"]
