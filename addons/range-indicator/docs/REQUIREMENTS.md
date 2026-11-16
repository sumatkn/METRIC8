# Range Indicator requirements

Captured: 2026-11-16 from the user's supplied requirements discussion. This document records behavior and organization only.

## 1. Icon

- The icon is movable and scalable.
- The icon can be themed.
- The icon has configurable options; the full option list remains to be defined.

## 2. Functionality

- Determine and show the player's range status relative to the current target.
- Update the icon itself to communicate status using overlays or an icon change.
- Attempt to recognize the player's class and apply its default functionality with the default theme.

## 3. Profiles

- Profiles specify the theme and functionality.
- Support class defaults with optional character overrides.
- A profile can apply different themes per class or the same theme across classes.
- A theme package supplies defaults; the user can override them.
- Initially use class-default functionality. Advanced functionality customization comes later.

## 4. Separation of responsibilities

Keep icon presentation/options, range-status functionality, and profile selection/configuration distinct in requirements. Their implementation is not prescribed here.

## Unresolved details

- Exact range states, thresholds, and class-specific behavior.
- Behavior for no target, invalid targets, or unavailable range information.
- Full option list and theme package contents.
- Precise precedence between individual theme settings and profile overrides.
- Supported client/build and available range information.

Do not assume exact numeric distance or promise accuracy before verifying the client capabilities.
