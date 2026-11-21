local _, addon = ...

-- Seed IDs identify spell families. Resolve a learned spellbook entry by localized name.
local melee = "melee"
local spell = "spell"
local ranged = "ranged"
local wand = "wand"
local presets = {
    WARRIOR = { { 78, melee } },                           -- Heroic Strike
    PALADIN = { { 20271, spell } },                       -- Judgement
    HUNTER = { { 2973, melee }, { 75, ranged } },          -- Raptor Strike, Auto Shot
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
    if result ~= false then return result end
    local info = read("table", spells.GetSpellInfo, id)
    -- A negative result with a minimum range does not tell us which boundary failed.
    if info and readable(info.minRange, "number") == 0 then return false end
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

function addon.GetRangeStatus(class)
    local exists = read("boolean", UnitExists, "target")
    if exists == false then return "none" end
    if exists == nil then return "unknown" end
    local attackable = read("boolean", UnitCanAttack, "player", "target")
    local dead = read("boolean", UnitIsDeadOrGhost, "target")
    if attackable == false or dead == true then return "invalid" end
    if attackable == nil or dead == nil then return "unknown" end

    local preset = presets[class]
    if not preset then return "unknown" end
    local checked, uncertain = false, false
    for _, probe in ipairs(preset) do
        local kind = probe[2]
        local equipment
        if kind == ranged or kind == wand then equipment = rangedEquipment() end
        if kind == melee or kind == spell or equipment == kind then
            local result = probeSpell(probe[1])
            if result == true then return kind end
            if result == false then checked = true else uncertain = true end
        elseif not equipment then
            uncertain = true
        end
    end
    if checked and not uncertain then return "out" end
    return "unknown"
end
