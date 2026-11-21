# Source

[`METRIC8_RangeCheck/`](METRIC8_RangeCheck/) is the complete install folder. The TOC loads the profiles, range detection, theme registry and icon before the startup controller. The addon has no embedded libraries.

## Theme packages

A separate addon can declare `## Dependencies: METRIC8_RangeCheck` in its TOC and register its theme from Lua:

```lua
METRIC8_RangeCheck.RegisterTheme("example", {
    icon = 134400,
    mode = "overlay",
    styles = {
        melee = {
            label = "M",
            color = { 0.3, 0.9, 0.5 },
            icon = 132223,
            -- overlay = "Interface\\AddOns\\ExampleTheme\\Melee",
        },
    },
})
```

IDs are lowercase and can contain letters, digits, underscores and hyphens. Registration returns false for invalid or duplicate IDs. Visual fields accept texture file IDs or paths. In overlay mode the optional `overlay` texture appears above the base icon. Replacement mode uses each status's `icon` when supplied. Both display the status label. The Default theme supplies omitted style fields.

Supported keys are `none`, `invalid`, `unknown`, `melee`, `ranged`, `spell`, `wand`, `out` and `deadzone`. The last key is reserved for a future supported detection rule. Select the registered theme with `/rangecheck theme example`.
