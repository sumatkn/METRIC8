# Changelog

## Unreleased

- Added the native Wing Clip action-bar range check for Hunters.
- Added a distance readout in meters with estimated bands or unavailable state, and improved LOS badge contrast and visibility.

- Added opt-in `/rangecheck debug on` to log changes in target eligibility and range responses, plus recent line-of-sight errors, without repeating unchanged results.

- Added a separate corner badge for recent client-reported line-of-sight errors and `/rangecheck status` for Hunter range diagnostics.

- Updated 0.1.1-dev to use Wing Clip as the Hunter melee probe, keeping Auto Shot for ranged checks.
- Labeled no target `NONE`, nonattackable or dead targets `N/A`, and unavailable range `?`.

- Added the 0.1.0-dev proof of concept with one movable, scalable icon and bundled placeholder art.
- Added class range presets, conservative handling of unavailable results, and optional wand and Hunter ranged-weapon checks.
- Added slash settings, class and per-character persistence, and external theme registration.
- Documented the Forever API review, source installation, and validation.

- Confirmed METRIC8: RangeCheck name and suite inclusion; migrated project scaffold and reconciled requirements v0.2.

- Established a requirements scaffold and project file sections.
- No installable addon released.
