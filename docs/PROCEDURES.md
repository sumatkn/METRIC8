# Procedures and approval register

## Authorized baseline

| ID | Procedure | Status and authority |
| --- | --- | --- |
| P-001 | Use sumatkn/METRIC8 as the suite repository | Confirmed by the user's setup request, 2026-11-16 |
| P-002 | Maintain suite scope, project list, rules, procedures, and working memory | Confirmed by the user's setup request, 2026-11-16 |
| P-003 | Give each addon/tool a dedicated section for documentation and files, including distributions | Confirmed by the user's setup request, 2026-11-16 |

The directory names and templates are reversible organizational choices made for this setup. They are not approval of a runtime architecture or a release policy.

## Baseline execution

### P-001: Repository context

Read the current repository and relevant instructions before working. Keep suite changes in `docs/` and project changes in the matching project section. Preserve existing license and unrelated content.

### P-002: Documentation and handoff

Update the relevant requirements when the user changes them. Record the decision, date, authority, and any superseded decision. Update working memory with the current state, validation, open questions, and next action. Do not store entire chats or personal information.

### P-003: Project section

Create a project section from the template. Keep source in `src/`, documentation in `docs/`, art/resources in `assets/`, and packaged files or a download index in `dist/`. Clearly label missing imports and missing builds.

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
