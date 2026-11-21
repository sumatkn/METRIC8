local _, addon = ...

local states = { "none", "invalid", "unknown", "melee", "ranged", "spell", "wand", "out", "deadzone" }
local default = {
    icon = 134400, -- Blizzard's question-mark icon.
    mode = "overlay",
    styles = {
        none =     { label = "NONE",  color = { 0.55, 0.55, 0.55 } },
        invalid =  { label = "N/A",  color = { 0.65, 0.65, 0.65 } },
        unknown =  { label = "?",  color = { 0.95, 0.79, 0.34 } },
        melee =    { label = "M",  color = { 0.30, 0.95, 0.45 }, icon = 132223 },
        ranged =   { label = "R",  color = { 0.30, 0.90, 0.70 }, icon = 132222 },
        spell =    { label = "S",  color = { 0.50, 0.80, 1.00 }, icon = 136243 },
        wand =     { label = "W",  color = { 0.75, 0.64, 1.00 }, icon = 135139 },
        out =      { label = "OUT", color = { 1.00, 0.38, 0.34 }, icon = 132090 },
        deadzone = { label = "DZ", color = { 1.00, 0.62, 0.24 } },
    },
}
local themes = { default = default }

local function texture(value)
    if (type(value) == "number" and value > 0) or (type(value) == "string" and value ~= "") then
        return value
    end
end

local function color(value)
    if type(value) ~= "table" then return nil end
    for index = 1, 3 do
        local channel = value[index]
        if type(channel) ~= "number" or not (channel >= 0 and channel <= 1) then return nil end
    end
    return { value[1], value[2], value[3] }
end

local function registerTheme(id, definition)
    if type(id) ~= "string" or not id:match("^[a-z0-9_-]+$") or themes[id] or type(definition) ~= "table" then
        return false
    end
    local theme = {
        icon = texture(definition.icon) or default.icon,
        mode = definition.mode == "replace" and "replace" or "overlay",
        styles = {},
    }
    local styles = type(definition.styles) == "table" and definition.styles or {}
    for _, state in ipairs(states) do
        local source = type(styles[state]) == "table" and styles[state] or {}
        local fallback = default.styles[state]
        theme.styles[state] = {
            icon = texture(source.icon) or fallback.icon,
            overlay = texture(source.overlay),
            label = type(source.label) == "string" and source.label or fallback.label,
            color = color(source.color) or fallback.color,
        }
    end
    themes[id] = theme
    if addon.ApplyProfile then addon.ApplyProfile() end
    return true
end

METRIC8_RangeCheck = { RegisterTheme = registerTheme }

function addon.GetTheme(id)
    return type(id) == "string" and themes[id] or default
end

function addon.HasTheme(id)
    return themes[id] ~= nil
end
