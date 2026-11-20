# Procedures and approval register

## Authorized baseline

| ID | Procedure | Status and authority |
| --- | --- | --- |
| P-001 | Use sumatkn/METRIC8 as the suite repository | Confirmed by the user's setup request, 2026-11-16 |
| P-002 | Maintain suite scope, project list, rules, procedures, and working memory | Confirmed by the user's setup request, 2026-11-16 |
| P-003 | Give each addon/tool a dedicated section for documentation and files, including distributions | Confirmed by the user's setup request, 2026-11-16 |
| P-004 | Review Forever client compatibility before addon work | Confirmed by maintainer, 2026-11-20 |

The directory names and templates are reversible organizational choices made for this setup. They are not approval of a runtime architecture or a release policy.

## Baseline execution

### P-001: Repository context

Read the current repository and relevant instructions before working. Keep suite changes in `docs/` and project changes in the matching project section. Preserve existing license and unrelated content.

### P-002: Documentation and handoff

Update the relevant requirements when the user changes them. Record the decision, date, authority, and any superseded decision. Update working memory with the current state, validation, open questions, and next action. Do not store entire chats or personal information.

### P-003: Project section

Create a project section from the template. Keep source in `src/`, documentation in `docs/`, art/resources in `assets/`, and packaged files or a download index in `dist/`. Clearly label missing imports and missing builds.

### P-004: Forever compatibility review

Before starting or resuming WoW: Forever addon work, identify the live game version, client build and interface number where available. Compare the Forever UI source and generated API documentation with the last reviewed build. Check Blizzard hotfixes and addon-author reports for behavioral changes even when the signature is identical. Trace the APIs, wrappers, dependencies and saved-data keys the task touches. Record the build, sources, affected paths and any behavior that still needs an in-game check. Reuse a current baseline when applicable and check for intervening hotfixes.

Use WoW's modified Lua 5.1 as the language baseline. Verify client extensions, load order, return values and restrictions on the target game flavor. Exercise missing, empty or restricted results as applicable. For identity-scoped data, preserve existing keys and records when identity is unavailable. Only associate a fallback identifier with an existing record when the mapping is established. Label local Lua tests, client-source findings, live observations and announced changes separately.

### Compatibility baseline reviewed November 20, 2026

Forever 1.60.1 uses the Mainline UI family. The interface number (16001) and client build identify different things. The beta loader name changed from `require` to `import`; a module must already be loaded. Forever also applies secret-value and combat restrictions. Check each API used by the feature and the conditions on its results. [Forever API notes](https://warcraft.wiki.gg/wiki/Patch_1.60.1/API_changes/notes) · [WoW Lua](https://warcraft.wiki.gg/wiki/Lua_functions)

From launch build 70790 through 71037, the Forever source records changes to Battle.net whispers, party invitation data, tradeskill and outfit APIs, mail and encoding, and Battle.net realm checks. Build 71037 adds `C_BattleNet.IsGameAccountOnSameRealm` and `hasRealmInfo`. An addon author separately observed `GetRealmName()` returning an empty string. Treat empty realm names as unknown and preserve historical profiles. The UI export cannot establish native runtime behavior in every context. [Forever build history](https://github.com/Gethe/wow-ui-source/commits/forever/) · [71037 changes](https://github.com/Gethe/wow-ui-source/commit/734f065329cff4992835b01a84f210a297db91b6) · [Realm-name report](https://www.reddit.com/r/wowaddons/comments/1y1etab/addon_creators_todays_forever_patch_blanks_the/)

## Proposed workflows, not yet approved

| ID | Recommendation | Decision still needed |
| --- | --- | --- |
| P-101 | Use focused branches and pull requests for substantive implementation | Whether this is required or direct commits are preferred |
| P-102 | Use project-specific versions and tags such as `range-indicator/v0.1.0` | Versioning and naming convention |
| P-103 | Host versioned ZIPs/binaries in GitHub Releases, linked from each project's `dist/README.md` | Release assets versus committed binary files |
| P-104 | Verify package contents and document in-game smoke testing before releases | Required checks and release authority |

If P-103 is selected, each project still retains its own download section in the repository. Small required assets can stay with source. No release is created by this setup.

## Procedure changes

An explicit user decision or maintainer approval can confirm a proposal. Record its date and authority in this file and the decision register. Do not mark a recommendation approved merely because it was drafted.
