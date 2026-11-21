local name, C = ...
C.builtins = {
    { title = "I Kill Two Dwarves", credit = "Excerpt · retired male troll /silly", verses = {{"I kill two dwarves in the morning"}} },
    { title = "Dark Iron Song", credit = "Excerpt · the Dark Iron Herald's Brewfest raid", verses = {{"We've come ta drink yer brew!"}} },
    { title = "Thunderbrew", credit = "Excerpt · Grimbooze Thunderbrew's Westfall quest rhyme", verses = {{"For Thunderbrew Lager comes in a keg!"}} },
    { title = "Lament of the Highborne", credit = "Excerpt · Sylvanas and the Highborne Lamenters", verses = {{"Anar'alah, anar'alah belore"}} },
    { title = "O Thanagor", credit = "Excerpt · the recurring Arthas vocal theme", verses = {{"An Karanir Thanagor"}} },
    { title = "The Traveler's Path", credit = "Song of Liu Lang · lyrics unverified", verses = {} },
    { title = "Song of the Vale", credit = "Excerpt · the Jade Forest quest scroll", verses = {{"Where every hearth brings peaceful ease"}} },
    { title = "Daughter of the Sea", credit = "Excerpt · Kul Tiran shanty about Jaina Proudmoore", verses = {{"Beware, beware the Daughter of the Sea."}} },
    { title = "Abby Lewis's rhymes", credit = "Excerpt · Glenbrook Homestead, Drustvar", verses = {{"Miss Mary turned her back on us"}} },
    { title = "Nightsong", credit = "Excerpt · night elf vocal theme", verses = {{"Elune adore"}} },
    { title = "Power of the Horde", credit = "Excerpt · Elite Tauren Chieftain", verses = {{"I am the son of the wind and rain"}} },
    { title = "Rogues Do it from Behind", credit = "Excerpt · Elite Tauren Chieftain", verses = {{"I love to one shot mages"}} },
    { title = "I Am Murloc", credit = "Excerpt · Elite Tauren Chieftain", verses = {{"I am more than a fish"}} },
    { title = "Lament of Captain Placeholder", credit = "Excerpt · Eledainn; later covered by Cranius", verses = {{"Farewell to thee, Placeholder"}} },
    { title = "Darrowshire", credit = "Excerpt · Cranius", verses = {{"I think he went off to war"}} },
    { title = "I'm a Medieval Man", credit = "Excerpt · Warcraft II bonus track", verses = {{"I'm a Medieval Man"}} },
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
