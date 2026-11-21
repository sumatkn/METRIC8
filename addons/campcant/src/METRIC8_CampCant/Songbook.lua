local name, C = ...
C.builtins = {
    { title = "Dark Iron Brewfest Song (excerpt)", credit = "Dark Iron Herald at Brewfest", verses = {
        {"We've come ta drink yer brew!"},
    }},
    { title = "I Kill Two Dwarves (excerpt)", credit = "Retired male troll /silly", verses = {
        {"I kill two dwarves in the morning"},
    }},
    { title = "The Last Zepp out of Brill", credit = "Original Undercity travel song", verses = {
        {"The tower bell rang in the Tirisfal rain. I ran with a boot half tied."},
        {"My boot made the deck of the Orgrimmar zepp. The rest of me missed the ride."},
        {"If you see one boot on a goblin's stall, with a fine brass buckle still bright,"},
        {"Tell him the left one's waiting in Brill for the first flight back tonight."},
    }},
    { title = "Crossroads Watch", credit = "Original Barrens call and response", verses = {
        {"Who keeps watch by the Crossroads fire? A plainstrider pecking the pot."},
        {"Who took the road by the Merchant Coast? The runner whose hearth we forgot."},
        {"Bank up the coals till his boots come home. Leave one bowl out of the stack."},
        {"There's dust on the road and a shape in the dusk. Pass it along: he's back."},
    }},
}

local voices = {
    Troll = {"Listen close, mon. ", "Sing it, broda! "},
    Dwarf = {"Och, gather round! ", "Aye, lads! "},
    Orc = {"Lok'tar! ", "Clan, sing it! "},
    Scourge = {"Ah, I remember. ", "While breath lasts... "},
    Tauren = {"By the Earth Mother's fire, ", "Hear us, friends. "},
    NightElf = {"Under these stars, ", "By Elune, "},
    Gnome = {"On my count! ", "Right on the beat! "},
    Human = {"Come, friends! ", "One more round! "},
    BloodElf = {"Gather, friends. ", "By the Sunwell, "},
    Draenei = {"Come, travelers. ", "In the Light, "},
}
function C.raceLine(text, index, enabled)
    if not enabled then return text end
    local _, race = UnitRace("player")
    local voice = voices[race]
    if not voice then return text end
    local prefix = index % 4 == 1 and voice[1] or index % 4 == 0 and voice[2]
    local swaps
    if race == "Troll" then swaps = {the="da", The="Da", them="dem", Them="Dem"}
    elseif race == "Dwarf" then swaps = {my="me", My="Me", your="yer", Your="Yer"} end
    local line = swaps and text:gsub("%a+", swaps) or text
    if #line > 255 then line = text end
    if prefix and #prefix + #line <= 255 then return prefix .. line end
    return line
end

function C.clean(text)
    return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

function C.validate(song)
    if type(song.title) ~= "string" or C.clean(song.title) == "" then return "Give the song a title." end
    if #song.verses == 0 then return "Add at least one verse." end
    for i, verse in ipairs(song.verses) do
        local line = verse[1]
        if C.clean(line) == "" or #line > 255 or line:find("[%c|]") then
            return "Verse " .. i .. " needs one plain chat line of 1–255 bytes."
        end
    end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, _, loaded)
    if loaded ~= name then return end
    self:UnregisterEvent("ADDON_LOADED")
    if type(METRIC8_CampCantDB) ~= "table" then METRIC8_CampCantDB = {} end
    C.db = METRIC8_CampCantDB
    if type(C.db.songs) ~= "table" then C.db.songs = {} end
end)
