local _, addon = ...

-- Seed IDs identify spell families. Resolve a learned spellbook entry by localized name.
local melee = "melee"
local spell = "spell"
local ranged = "ranged"
local wand = "wand"
local presets = {
    WARRIOR = { { 78, melee } },                           -- Heroic Strike
    PALADIN = { { 20271, spell } },                       -- Judgement
    HUNTER = { { 2974, melee }, { 75, ranged } },          -- Wing Clip, Auto Shot
    ROGUE = { { 1752, melee } },                          -- Sinister Strike
    PRIEST = { { 589, spell }, { 5019, wand } },           -- Shadow Word: Pain, Shoot
    SHAMAN = { { 403, spell } },                          -- Lightning Bolt
    MAGE = { { 133, spell }, { 5019, wand } },             -- Fireball, Shoot
    WARLOCK = { { 686, spell }, { 5019, wand } },          -- Shadow Bolt, Shoot
    DRUID = { { 5176, spell } },                          -- Wrath
}

local function readable(value, expected)
    if issecretvalue and issecretvalue(value) then return nil end
    if type(value) == expected then return value end
end

local function read(expected, func, ...)
    if type(func) ~= "function" then return nil end
    local ok, value, extra = pcall(func, ...)
    if ok then return readable(value, expected), extra end
end

function addon.GetPlayerClass()
    if type(UnitClass) == "function" then
        local ok, _, class = pcall(UnitClass, "player")
        if ok then return readable(class, "string") end
    end
end

-- Read the action slot's range state, never its visual tint or activation state.
local function probeAction(seed)
    local bar = C_ActionBar or {}
    local slots = read("table", bar.FindSpellActionButtons, seed)
    if not slots or #slots == 0 then return nil, "no Wing Clip slot" end
    for _, value in ipairs(slots) do
        local slot = readable(value, "number")
        if slot and read("boolean", bar.HasRangeRequirements, slot) == true then
            local result = read("boolean", bar.IsActionInRange, slot, "target")
            if result ~= nil then return result end
        end
    end
    return nil, "Wing Clip slot gave no usable result"
end

local function probeSpell(seed)
    local spells, book = C_Spell or {}, C_SpellBook or {}
    local name = read("string", spells.GetSpellName, seed)
    if not name then return nil end
    local slot, bank = read("number", book.FindSpellBookSlotForSpell, name, false, false, false, false)
    bank = readable(bank, "number")
    if not slot or not bank or not Enum or not Enum.SpellBookSpellBank or bank ~= Enum.SpellBookSpellBank.Player then
        return nil
    end
    local entry = read("table", book.GetSpellBookItemInfo, slot, bank)
    local id = entry and readable(entry.spellID, "number")
    if not id then return nil end
    local result = read("boolean", spells.IsSpellInRange, id, "target")
    if result ~= false then return result, id end
    local info = read("table", spells.GetSpellInfo, id)
    -- A negative result with a minimum range does not tell us which boundary failed.
    if info and readable(info.minRange, "number") == 0 then return false end
end

function addon.GetDistanceText(status, spellID)
    if status == "none" then return "" end
    local squared, checked = read("number", UnitDistanceSquared, "target")
    if readable(checked, "boolean") == true and squared and squared >= 0 and squared < math.huge then
        return ("%.1f m"):format(math.sqrt(squared) * 0.9144)
    end

    -- A positive spell check can support an approximate band, not a position.
    local info = spellID and read("table", C_Spell and C_Spell.GetSpellInfo, spellID)
    local min = info and readable(info.minRange, "number")
    local max = info and readable(info.maxRange, "number")
    if not (min and max and min >= 0 and max > min and max < math.huge) then return "— m" end
    local upper = math.ceil(max * 0.9144)
    if min == 0 then return ("~≤%d m"):format(upper) end
    return ("~%d–%d m"):format(math.floor(min * 0.9144), upper)
end

local function rangedEquipment()
    local slot = read("number", GetInventorySlotInfo, "RangedSlot")
    if not slot or type(GetInventoryItemID) ~= "function" then return nil end
    local ok, id = pcall(GetInventoryItemID, "player", slot)
    if not ok or (issecretvalue and issecretvalue(id)) then return nil end
    if id == nil then return "empty" end
    if type(id) ~= "number" or not C_Item or type(C_Item.GetItemInfoInstant) ~= "function" then return nil end
    local found, _, _, _, _, _, class, subclass = pcall(C_Item.GetItemInfoInstant, id)
    if not found then return nil end
    class, subclass = readable(class, "number"), readable(subclass, "number")
    if not class or not subclass then return nil end
    if class == 2 then -- Weapon class, using the client item subclass IDs.
        if subclass == 19 then return wand end
        if subclass == 2 or subclass == 3 or subclass == 18 then return ranged end
    end
    return "other"
end

function addon.GetRangeStatus(class, details)
    local exists = read("boolean", UnitExists, "target")
    if exists == false then return "none" end
    if exists == nil then return "unknown" end
    local attackable = read("boolean", UnitCanAttack, "player", "target")
    local dead = read("boolean", UnitIsDeadOrGhost, "target")
    if details then
        details[#details + 1] = "attackable=" .. tostring(attackable) .. ", dead=" .. tostring(dead)
    end
    if attackable == false or dead == true then return "invalid" end
    if attackable == nil or dead == nil then return "unknown" end

    local preset = presets[class]
    if not preset then return "unknown" end
    local checked, uncertain = false, false
    local positive, positiveSpell
    for _, probe in ipairs(preset) do
        local kind = probe[2]
        local equipment
        if kind == ranged or kind == wand then equipment = rangedEquipment() end
        if kind == melee or kind == spell or equipment == kind then
            local seed = probe[1]
            local result, id, actionNote
            local source = "spellbook"
            if class == "HUNTER" and kind == melee then result, actionNote = probeAction(seed) end
            if result == nil then
                result, id = probeSpell(seed)
            else
                source = "action bar"
            end
            if details then
                local note = actionNote and (" [" .. actionNote .. "]") or ""
                details[#details + 1] = kind .. " (" .. seed .. ", " .. source .. ")=" .. tostring(result) .. note
            end
            if result == true then
                if not details then return kind, id end
                if not positive then positive, positiveSpell = kind, id end
            elseif result == false then
                checked = true
            else
                uncertain = true
            end
        else
            if details then
                details[#details + 1] = kind .. " equipment=" .. tostring(equipment)
            end
            if not equipment then uncertain = true end
        end
    end
    if positive then return positive, positiveSpell end
    if checked and not uncertain then return "out" end
    return "unknown"
end
