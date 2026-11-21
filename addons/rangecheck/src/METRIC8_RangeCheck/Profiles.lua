local _, addon = ...

local defaults = { scale = 1, x = 0, y = -130, locked = true, mode = "auto", theme = "default" }

function addon.LoadProfiles(class)
    if type(METRIC8_RangeCheckDB) ~= "table" then METRIC8_RangeCheckDB = {} end
    local db = METRIC8_RangeCheckDB
    if type(db.global) ~= "table" then db.global = {} end
    if type(db.classes) ~= "table" then db.classes = {} end
    if class and type(db.classes[class]) ~= "table" then db.classes[class] = {} end
    if type(METRIC8_RangeCheckCharacterDB) ~= "table" then METRIC8_RangeCheckCharacterDB = {} end
    addon.global = db.global
    addon.classProfile = class and db.classes[class] or {}
    addon.character = METRIC8_RangeCheckCharacterDB
end

function addon.ActiveProfile()
    return addon.character.enabled == true and addon.character or addon.classProfile
end

local function numberInRange(value, low, high)
    if type(value) == "number" and value >= low and value <= high then return value end
end

function addon.ResolveProfile()
    local class, global = addon.classProfile, addon.global
    local character = addon.character.enabled == true and addon.character or {}
    local mode = character.mode or class.mode
    local locked = character.locked
    if type(locked) ~= "boolean" then locked = class.locked end
    if type(locked) ~= "boolean" then locked = defaults.locked end
    return {
        scale = numberInRange(character.scale, 0.5, 2) or numberInRange(class.scale, 0.5, 2) or defaults.scale,
        x = numberInRange(character.x, -10000, 10000) or numberInRange(class.x, -10000, 10000) or defaults.x,
        y = numberInRange(character.y, -10000, 10000) or numberInRange(class.y, -10000, 10000) or defaults.y,
        locked = locked,
        mode = (mode == "overlay" or mode == "replace" or mode == "auto") and mode or defaults.mode,
        theme = character.theme or class.theme or global.theme or defaults.theme,
    }
end
