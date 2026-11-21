# Compatibility and test notes

Reviewed November 21, 2026 against the Forever 1.60.1 build 71037 UI export (interface 16001), still the November 20 baseline. The [generated chat API](https://github.com/Gethe/wow-ui-source/blob/734f065329cff4992835b01a84f210a297db91b6/Interface/AddOns/Blizzard_APIDocumentationGenerated/ChatInfoDocumentation.lua) exposes restricted C_ChatInfo.SendChatMessage with no delivery result. Forever [API notes](https://warcraft.wiki.gg/wiki/Patch_1.60.1/API_changes/notes) document the hardware-event requirement for outdoor SAY. Checked the [November 20 hotfix listing](https://worldofwarcraft.blizzard.com/en-us/news/24315281/wow-forever-hotfixes-november-20-2026). Public sends occur only from direct clicks. The client can decline delivery. Realm identity is unused.

Lua mock checks passed for creating and saving two verses, discarding edits, validating durations and UTF-8 byte limits, race voice, rehearsal advancement and completion, public send gating, lockdown retry, double clicks, and stopping. Live-client layout, saved variables across reloads, and outdoor /say delivery await in-game verification.

A player encountered a suppressed error in 0.1.0. The original trace was unavailable in the inspected on-disk logs. Version 0.1.1 reports caught chat-send errors and client blocked-action events attributed to CampCant. Root cause is unconfirmed.

0.1.2 uses manual advancement in both modes. Saved verses from earlier versions are read by their text field. A caught chat failure or synchronous blocked-action event leaves the cursor on the same verse for chat-box fallback. A generic failed-action notice alone does not identify which addon caused it.

Lua mock checks for 0.1.2 passed for immediate successive clicks, final verse retention, manual rehearsal, Stop, legacy verse data, blocked-action retry and preserving an open chat entry.

In-game evidence from 0.1.2 shows CampCant receiving ADDON_ACTION_BLOCKED with UNKNOWN() and one verse appearing in SAY. The client did not identify the protected function. Version 0.1.3 uses ChatFrameUtil.OpenChat directly for public verses. Submission stays with Blizzard's edit box. Local mock tests cover manual rehearsal, public chat preparation, preserving a pending input, final verse and Stop. Live verification of 0.1.3 is pending.

0.1.4 uses Blizzard's [SecureActionButtonTemplate](https://github.com/Gethe/wow-ui-source/blob/734f065329cff4992835b01a84f210a297db91b6/Interface/AddOns/Blizzard_FrameXML/SecureTemplates.lua), configured with a literal single-line /say macro before the click. The inherited OnClick owns execution. PostClick advances the cursor. The secure visibility driver hides the performance controls during combat. Live one-click delivery awaits verification.

0.1.5 follows the 16-entry research catalog. The Traveler's Path is listed as a reference because the [song's documentation](https://warcraft.wiki.gg/wiki/The_Traveler%27s_Path) identifies no official lyrics. The remaining entries contain excerpts. Player songs use the existing account-wide saved-variable list.

0.1.6 replaces the 16-entry excerpt catalog with ten supplied songs. The title is taken from line one. Line two is source metadata. Each subsequent nonblank line is a separate verse.
