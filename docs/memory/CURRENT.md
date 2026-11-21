# Suite working memory

Updated: 2026-11-21.

## Current objective

Establish METRIC8 as the umbrella repository with consistent addon/tool sections and durable project governance.

## Observed starting state

The public repository contained README.md and an MIT LICENSE only. There was no addon source, package, build configuration, or existing repository instruction file.

## Current state

- Follow [P-004](../PROCEDURES.md#p-004-forever-compatibility-review) before addon work. The November 20 baseline is Forever build 71037. The realm-name report remains unverified in our client.

- Suite scope, project registry, collaboration rules, procedure register, decision register, and contributor instructions are established.
- A reusable project template defines source, docs, assets, and distribution sections.
- [METRIC8: RangeCheck](../../addons/rangecheck/README.md) is a confirmed suite member with requirements only, no source code or build.
- Database tooling is listed as a candidate; its previous files and architecture have not been imported.
- [METRIC8: NoTHX](../../addons/nothx/README.md) implements the unspent talent reminder filter. The maintainer confirmed 0.1.0 in game.
- [METRIC8: CampCant](../../addons/campcant/README.md) 0.1.6 ships ten songs and 156 verses. Mock playback passed. The maintainer confirmed 0.1.6 works in game.

## Confirmed constraints

- Suite-level documentation stays distinct from individual project requirements.
- Each project has its own file and documentation section.
- Proposed procedures must not be represented as approved.
- Repository working memory is public technical context only.

## Open questions

1. Confirm the remaining suite roster and names (RangeCheck, CampCant, NoTHX confirmed).
2. Choose GitHub Release assets or committed distribution files.
3. Choose whether substantive changes require a pull request.
4. Verify the target client/build before implementation.

## Next action

Continue RangeCheck requirements one component at a time. Address remaining roster and distribution policy separately. Before implementation, follow P-004.

## Validation and limits

RangeCheck path and naming reconciled 2026-11-21; documentation-only, no client or gameplay testing. Foundation validation also covers links and existing license; see project memory.

## Handoff maintenance

Replace stale state when work changes. Record lasting decisions in the decision register rather than accumulating chat transcripts here.
