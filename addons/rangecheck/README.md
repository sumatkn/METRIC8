# METRIC8: RangeCheck

**RangeCheck** is a WoW: Forever proof of concept. See the [source install instructions](dist/README.md) and the [compatibility review and smoke test](docs/COMPATIBILITY.md).

One movable, scalable icon shows the current target's range for selected attacks. The Default theme uses placeholder Blizzard art and a colored status label. The icon starts locked and stays visible so its location is easy to find.

## Status labels

| Label | Meaning |
| --- | --- |
| `M`, `R`, `S`, `W` | A preset melee attack, ranged weapon attack, offensive spell, or wand attack is in range. When both checks succeed, Hunter shows melee and wand-capable casters show spell. |
| `OUT` | All applicable preset probes returned an interpretable negative. |
| `?` | Evidence was unavailable or ambiguous. This includes Hunter Auto Shot failures where the client cannot distinguish too close from too far. |
| `NONE` | No target selected. |
| `N/A` | The selected target is dead or cannot be attacked. |

Hunters use learned Wing Clip for melee and Auto Shot for ranged weapon range. If Wing Clip is unavailable, or Auto Shot cannot distinguish too close from too far, a result may remain Unknown.

Range is based on the client’s spell checks. A red `LOS!` in the upper-right corner shows a recent line-of-sight error from WoW independently of the range label. The badge clears after two seconds or a target change. The UI error does not identify the affected unit, and an empty corner means no recent error was observed. RangeCheck does not start attacks or check facing.

## Commands

Enter `/rangecheck` for help. Use the commands in the table after `/rangecheck`.

| Command | Effect |
| --- | --- |
| `debug on`, `debug off` | Start or stop reporting changes in range results and new line-of-sight errors in chat. Debug mode is off after reload. |
| `status` | Print the loaded addon version, current range state and available probe results in chat. |
| `unlock`, `lock` | Enable left-dragging or lock the icon. |
| `scale 1.25` | Set scale from 0.5 to 2. Use `scale inherit` to clear it. |
| `resetpos` | Clear the saved position at the selected scope. |
| `mode auto`, `mode overlay`, `mode replace` | Use the theme's preference, keep the base art with overlays, or use status art when available. `mode inherit` clears the setting. |
| `override on`, `override off` | Enable or disable this character's saved overrides. |
| `theme <id>`, `theme inherit` | Select a registered theme or clear the assignment. Prefix with `global` for the shared theme, `class` for this class, or `char` for this character. |

Edits and dragging default to class settings unless the character override is enabled. Prefix settings commands with `class` or `char` to edit that scope directly. Settings inherit from class to character, and themes resolve in order from enabled character to class to global to Default.

## Project sections

- [Requirements](docs/REQUIREMENTS.md)
- [Working memory](docs/MEMORY.md)
- [Distribution](dist/README.md)
- [Changelog](CHANGELOG.md)

- [Source and theme registration](src/README.md)
