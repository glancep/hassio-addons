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

### Highlights

- PostgreSQL support, booking-email import, live flight status, and per-trip
  add-on controls.
- Full release notes: [Trek v5.2.0](https://github.com/liketrek/TREK/releases/tag/v5.2.0).

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