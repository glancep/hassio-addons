# Changelog

## v5.2.0 - database and trip updates

Updated the bundled Trek image from 3.4.1 to 5.2.0.

### Upgrade notes

- Back up the add-on before updating. Trek 5.2.0 migrates the database on its
  first start.
- Keep the existing `encryption_key` unchanged. Since Trek 5.0.0, startup
  stops if `ENCRYPTION_KEY` differs from the key used to encrypt stored data;
  restore the old key or rotate it using Trek's rotation script.
- Trek 5.1.0 uses Trek-hosted map services by default. To opt out, set
  `TREK_SERVICES=off` in `env_vars`; `TREK_PLACES_ENABLED=false` also disables
  searches against Trek's place index.
- API clients should migrate from login-response tokens to session cookies;
  Trek still returns the token, but marks it deprecated.

### Upstream highlights since v3.4.1

- **v4.0.0:** Added a purpose-built mobile interface, the Trek Studio photo-book
  designer, updated Vacay planning, and configurable external storage.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v4.0.0)
- **v4.1.0:** Changed the default basemap to OpenFreeMap, expanded the MCP
  tools, enabled plugins to publish tools, and introduced a versioned public
  API. This release also had a map regression that made trips unusable;
  **v4.1.1 fixed it**.
  [v4.1.0](https://github.com/liketrek/TREK/releases/tag/v4.1.0) /
  [v4.1.1](https://github.com/liketrek/TREK/releases/tag/v4.1.1)
- **v4.2.0:** Expanded Studio editing and plugin settings, with five
  backward-compatible, additive database migrations.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v4.2.0)
- **v4.2.1:** Fixed security issues and offline-map handling; installed PWAs
  needed one online reload and offline maps needed to be downloaded again.
  Expense balances also changed for unpaid expenses. No schema or breaking
  changes.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v4.2.1)
- **v4.3.0:** Added Trek Places search and offline place data, plus a
  continuous road-trip planner with route alternatives and driving limits.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v4.3.0)
- **v4.3.1:** Fixed planner, map, and accommodation check-in scheduling issues.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v4.3.1)
- **v4.3.2:** Road-trip days can start and end at booked stays; days can be
  removed individually.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v4.3.2)
- **v4.3.3:** Improved OIDC and integration connections when hostnames resolve
  to both usable and link-local addresses, while strengthening protections for
  user-supplied URLs.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v4.3.3)
- **v4.3.4:** Updated Node.js to a security-patched version.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v4.3.4)
- **v5.0.0:** Added Tours, a redesigned photo-book studio, and an AI assistant.
  The upgrade automatically migrates the database and first creates a
  pre-migration copy; allow free disk space for a full database copy.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v5.0.0)
- **v5.0.1:** Fixed assistant compatibility with several AI providers and
  models.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v5.0.1)
- **v5.1.0:** Switched place, address, and route services to Trek-hosted
  services by default; improved search and routing and added Hebrew support.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v5.1.0)
- **v5.1.1:** Fixed assistant and map-service connectivity issues.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v5.1.1)
- **v5.1.2:** Fixed Synology photo metadata, packing-list weight saves, and
  mobile trip loading and navigation.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v5.1.2)
- **v5.1.3:** Fixed SSO and passkey sign-in handoff for Trek's test mobile apps.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v5.1.3)
- **v5.1.4:** Migrated Vacay to a holiday provider that remains available after
  January 2027 and fixed AirTrail API-key handling when changing hosts.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v5.1.4)
- **v5.2.0:** Added PostgreSQL support, booking-email import, live flight
  status, per-trip add-on controls, trip PDFs, and more cost options. The
  database migrates on first startup.
  [Release notes](https://github.com/liketrek/TREK/releases/tag/v5.2.0)

## v3.4.1 - bug fixes

### Fixes:

-   fix(transit): lead arrive-by results with the latest arrival ([#1479](https://github.com/liketrek/TREK/issues/1479))
-   fix(transit): lead arrive-by results with the latest arrival ([#1479](https://github.com/liketrek/TREK/issues/1479))
-   fix(reservations): run AirTrail modal hooks before the isOpen early return ([#1602](https://github.com/liketrek/TREK/issues/1602))
-   fix(planner): only draw the check-in-day hotel morning leg when provably at/after check-in ([#1597](https://github.com/liketrek/TREK/issues/1597)) ([#1607](https://github.com/liketrek/TREK/pull/1607))
-   fix(notifications): never fall back to the admin ntfy topic for per-user sends ([#1608](https://github.com/liketrek/TREK/issues/1608))
-   chore: correct shields.io url
-   chore: update helm repo link
-   fix(atlas): make Kosovo selectable on the Atlas map ([#1609](https://github.com/liketrek/TREK/issues/1609))
-   chore: normalize docker image references to mauriceboe/trek (lowercase)
-   fix(memories): honor Synology skip-SSL on photo streaming ([#1611](https://github.com/liketrek/TREK/issues/1611))
-   chore: make chart.liketrek.com the canonical helm chart url
-   feat(plugins): prefer the registry's resolved store screenshot ([#1613](https://github.com/liketrek/TREK/pull/1613))

### What's Changed

-   v3.4.1 by [@jubnl](https://github.com/jubnl) & [@mauriceboe](https://github.com/mauriceboe) in [#1606](https://github.com/liketrek/TREK/pull/1606)

**Full Changelog**: [`v3.4.0...v3.4.1`](https://github.com/liketrek/TREK/compare/v3.4.0...v3.4.1)