# Changelog

## 0.0.1

- Initial testing release. Wraps `mauriceboe/trek:3.3.0`.
- Options: encryption key, timezone, log level, admin bootstrap credentials,
  app URL, allowed origins, OIDC/SSO.
- Persistent storage mapped via `/data` and symlinked into Trek's expected
  `/app/data` and `/app/uploads` paths.
- Watchdog against Trek's `/api/health` endpoint.
