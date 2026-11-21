# METRIC8

**Simple. Informational. Minimalistic.**

METRIC8 is the umbrella suite and development home for WoW: Forever addons and supporting tools. This repository keeps suite governance and shared planning alongside a dedicated section for every included project.

**Addons:** [METRIC8: NoTHX](addons/nothx/README.md) 0.1.0, [METRIC8: CampCant](addons/campcant/README.md) 0.1.6, and [METRIC8: RangeCheck](addons/rangecheck/README.md) 0.1.7-dev.

## Start here

- [Suite scope](docs/SCOPE.md)
- [Project list](docs/PROJECTS.md)
- [Rules of engagement](docs/RULES_OF_ENGAGEMENT.md)
- [Approved procedures and proposed workflows](docs/PROCEDURES.md)
- [Working memory](docs/memory/CURRENT.md)
- [Decision register](docs/DECISIONS.md)
- [Contributor and agent instructions](AGENTS.md)

## Repository sections

| Location | Purpose |
| --- | --- |
| `docs/` | Suite scope, project registry, governance, decisions, and working memory |
| `addons/<project-id>/` | Each in-game addon's source, docs, assets, and distribution files |
| `tools/<project-id>/` | Each supporting tool's source, docs, assets, and distribution files |
| `templates/project/` | Starting structure for an addon or tool |

See the [RangeCheck proof of concept](addons/rangecheck/README.md) and the [project list](docs/PROJECTS.md).

Each project has a `dist/` section for installable ZIPs, binaries where applicable, and a download index. Empty sections explicitly mean that files have not been imported or built. Suite membership does not by itself impose a shared runtime or dependency.

## License

Original repository content uses the existing [MIT license](LICENSE). Imported code, artwork, and datasets retain their own licenses and attribution requirements; inclusion does not relicense them.
