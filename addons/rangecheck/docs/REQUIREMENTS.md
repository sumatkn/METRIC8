# METRIC8: RangeCheck — requirements v0.2

Confirmed requirements baseline from the maintainer's November 16, 2026 decisions; naming updated to **METRIC8: RangeCheck**, short name **RangeCheck**. This is not a code or release specification.

## Purpose

Recognize the player's class automatically, apply appropriate default functionality with the bundled Default theme, and show the range status of the current target through **one icon** without mandatory configuration.

## 1. Icon

- Movable, independently scalable, themeable, and configurable.
- Displays range status either by changing the primary icon or by adding overlays; both are supported.
- Theme defines the default presentation method; user may override it via options.
- All initial graphics, including icons and overlays, are placeholders for later custom art.
- Specific options remain to be defined.

## 2. Range Detection & Status

- Identifies the target, determines attack-range eligibility, and updates the Icon as distance changes.
- Categories under consideration: melee, ranged weapons, spells, wands, out of range, and Hunter dead zone.
- Dead zone must be distinct from ordinary out-of-range: too far for melee but too close for ranged weapon attacks.
- Relevant class abilities, equipment and range-enhancing talents (e.g. Hunter Hawk Eye) must be considered when supported by the client.
- Exact measurement probes, class rules, priorities between simultaneous states, invalid/no-target handling, and unknown-range outcomes are unresolved.
- **Excluded:** facing/turning detection and facing-related cast-error indicators.

## 3. Profiles

- Automatically recognize class and apply predefined class-specific functionality and Default theme.
- **Class defaults with optional per-character overrides.** Persist settings and automatically reapply them.
- Theme assignment: shared globally, individually per class, and optionally overridden per character.
- Initially offer preset class functionality. Defer advanced ability selection, custom priorities, and build-specific customizations.
- Profiles configure behavior and appearance, not direct detection or rendering.

## 4. Theme package system

- Bundle a fully functional Default theme and support optional external theme packages.
- Themes define visuals, main icon artwork, overlays, and preferred presentation; user can override that preference.
- Themes do not calculate target range.
- Additional custom art, animation and advanced visual effects are deferred.

## 5. Boundaries and default behavior

Components remain separate: **Icon** renders, **Range Detection & Status** classifies, **Profiles** configure, **Themes** style. On startup: recognize class, apply defaults and character overrides, select theme, begin range detection, update the Icon. Must work without additional installation/configuration.

Development remains component-by-component. Do not infer exact distances or guarantee live compatibility before the approved P-004 client/API review.

## Open decisions

Detailed Icon options; per-class checks, overlapping statuses, priority, no/invalid-target handling, unknown-range behavior, and exact override precedence other than theme presentation-method overrides.
