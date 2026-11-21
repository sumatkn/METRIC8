local _, C = ...
local active
local currentButton, blocked
local stopPending

local function displayLine(text)
    local p = C.player
    p.line:SetText(text)
    local bottom = 110 + math.ceil(p.line:GetStringHeight())
    p.status:SetPoint("TOPLEFT", 14, -bottom)
    p:SetHeight(bottom + 25)
end

function C.stop()
    active = nil
    if InCombatLockdown() then stopPending = true; return end
    stopPending = false
    if C.player then C.showIdle() end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_ACTION_BLOCKED")
events:RegisterEvent("ADDON_ACTION_FORBIDDEN")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:SetScript("OnEvent", function(_, event, addon, action)
    if event == "PLAYER_REGEN_ENABLED" then
        if stopPending then C.stop() end
    elseif currentButton and addon == "METRIC8_CampCant" then
        blocked = true
        print("CampCant: " .. event .. " (" .. tostring(action) .. ")")
    end
end)

-- Arm the native button before the click. Only Blizzard's inherited OnClick
-- executes the macro. The addon updates the song position in PostClick.
function C.arm(button, song, index, public)
    local verse = song and song.verses[index]
    local line = verse and C.raceLine(verse[1], index, C.db.voice)
    if line and (line == "" or #line > 255 or line:find("[%c|]")) then line = nil end
    button:SetAttribute("macrotext1", public and line and ("/say " .. line) or nil)
    button:SetAttribute("type1", public and line and "macro" or nil)
    button:SetEnabled(line ~= nil)
end

function C.beforeClick(button)
    currentButton, blocked = button, false
end

function C.afterClick()
    currentButton = nil
    if blocked then C.player.status:SetText("WoW blocked this verse. Click to retry.") end
    return not blocked and not InCombatLockdown()
end

local function advance()
    local run = active
    if not run or run.index >= #run.song.verses then return end
    run.index = run.index + 1
    local line = C.raceLine(run.song.verses[run.index][1], run.index, C.db.voice)
    displayLine(line)
    C.player.status:SetText(("Verse %d/%d  •  %s"):format(run.index, #run.song.verses, run.public and "/say" or "Rehearsal"))
    C.arm(C.player.sing, run.song, run.index + 1, run.public)
end

function C.nextVerse()
    if C.afterClick() then advance() end
end

function C.start(song, public)
    if InCombatLockdown() or C.validate(song) then return end
    active = {song = song, public = public, index = 0}
    C.arm(C.player.start, nil, 1, false)
    C.player.stop:Enable()
    C.player.title:SetText(song.title)
    C.player:Show()
    advance()
end

function C.setVoice(enabled)
    C.db.voice = enabled
    if not active then C.showIdle(); return end
    if not active.public then
        displayLine(C.raceLine(active.song.verses[active.index][1], active.index, enabled))
    end
    C.arm(C.player.sing, active.song, active.index + 1, active.public)
end
