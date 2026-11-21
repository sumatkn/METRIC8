local name, C = ...
C.builtins = {
    { title = "Dark Iron Keg Raid", credit = "Brewfest herald arrangement", verses = {
        {"We've come ta drink yer brew!", 4},
        {"Boots on the boards and soot on the tap! Who rolled a keg onto me lap?", 6},
        {"Coren sent six of us up through the floor. Five brought a tankard. One brought a door.", 7},
        {"A door? Aye, lads, for the bill on the nail! Shut it behind us and roll home the ale!", 7},
    }},
    { title = "Two Dwarves at the Campfire", credit = "Answer song to the retired troll /silly", verses = {
        {"I kill two dwarves in the morning...", 4},
        {"That's where the old troll stopped for breath. Two beards leaned in and stared him down.", 6},
        {"One laid a copper beside the fire. One said, 'Bet he forgets the rest.'", 6},
        {"He took that copper and tuned his drum. 'For one more coin, you sing it, friends.'", 7},
    }},
    { title = "The Last Zepp out of Brill", credit = "Original Undercity travel song", verses = {
        {"The tower bell rang in the Tirisfal rain. I ran with a boot half tied.", 6},
        {"My boot made the deck of the Orgrimmar zepp. The rest of me missed the ride.", 6},
        {"If you see one boot on a goblin's stall, with a fine brass buckle still bright,", 6},
        {"Tell him the left one's waiting in Brill for the first flight back tonight.", 6},
    }},
    { title = "Crossroads Watch", credit = "Original Barrens call and response", verses = {
        {"Who keeps watch by the Crossroads fire? A plainstrider pecking the pot.", 5},
        {"Who took the road by the Merchant Coast? The runner whose hearth we forgot.", 5},
        {"Bank up the coals till his boots come home. Leave one bowl out of the stack.", 6},
        {"There's dust on the road and a shape in the dusk. Pass it along: he's back.", 6},
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

function C.readTime(text)
    local words = 0
    for _ in text:gmatch("%S+") do words = words + 1 end
    return math.max(3, math.ceil(words / 2.6) + 1)
end

function C.clean(text)
    return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

function C.validate(song)
    if type(song.title) ~= "string" or C.clean(song.title) == "" then return "Give the song a title." end
    if #song.verses == 0 then return "Add at least one verse." end
    for i, verse in ipairs(song.verses) do
        local line, seconds = verse[1], verse[2]
        if C.clean(line) == "" or #line > 255 or line:find("[%c|]") then
            return "Verse " .. i .. " needs one plain chat line of 1–255 bytes."
        end
        if seconds ~= nil and (not tonumber(seconds) or tonumber(seconds) < 2 or tonumber(seconds) > 120) then
            return "Use 2–120 seconds for verse " .. i .. ", or leave timing blank."
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
