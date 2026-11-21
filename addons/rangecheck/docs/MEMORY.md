# METRIC8: RangeCheck — working memory

Updated: 2026-11-21.

## Confirmed

- Full name: **METRIC8: RangeCheck**; short: **RangeCheck**. The former Range Indicator working name is superseded.
- Included in METRIC8 by explicit maintainer direction; project path `addons/rangecheck/` (renamed from `addons/range-indicator/`).
- Requirements v0.2: Icon, Range Detection & Status, Profiles, theme packages. [Requirements](REQUIREMENTS.md).
- Class-default profiles with optional character overrides; theme default presentation can be overridden; advanced functionality customization deferred.
- Facing and turning detection explicitly excluded.

## Actual status and next work

Proof of concept 0.1.2-dev is installable from source. Reversible defaults are one visible, locked icon, overlay presentation, and preset class checks. Available positive results take precedence over Unknown; among positive results Hunter favors melee and casters favor spells over wands. Missing or ambiguous evidence displays Unknown. Hunter dead zone is reserved until both boundaries can be established. Per-character settings use the client's native storage.

[P-004 review and validation](COMPATIBILITY.md) covers Forever 1.60.1 build 71037, interface 16001, and the passing local Lua mock. Next action is the documented live-client smoke test, especially spellbook resolution, combat restrictions, ranged equipment and reload persistence. The maintainer observed working Hunter ranged detection and unclear melee and target labels in 0.1.0-dev. The follow-up substitutes Wing Clip and clarifies the labels. Live confirmation of that revision is pending. The next revision adds a recent line-of-sight error badge and a read-only status command to diagnose the reported X and absent Hunter melee result. Live verification remains with the maintainer. Repository distribution is source-only pending the package and release decisions.
