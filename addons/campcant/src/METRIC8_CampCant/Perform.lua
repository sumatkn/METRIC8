local _, C = ...
local active

local function displayLine(text)
    local p = C.player
    p.line:SetText(text)
    local bottom = 110 + math.ceil(p.line:GetStringHeight())
    p.status:SetPoint("TOPLEFT", 14, -bottom)
    p:SetHeight(bottom + 25)
end

function C.stop()
    active = nil
    if C.player then C.showIdle() end
end

local function showVerse(run)
    local verse = run.song.verses[run.index]
    run.line = C.raceLine(verse[1], run.index, run.voice)
    run.duration = tonumber(verse[2]) or C.readTime(run.line)
    run.readyAt = nil
    if not run.public then run.readyAt = GetTime() + run.duration end
    C.player.start:Disable()
    C.player.stop:Enable()
    C.player.title:SetText(run.song.title)
    displayLine(run.line)
    C.player.sing:SetEnabled(run.public)
    C.player.status:SetText(("Verse %d/%d  •  %s"):format(run.index, #run.song.verses, run.public and "Ready for /say" or "Rehearsal"))
end

function C.start(song, public)
    if C.validate(song) then return end
    C.stop()
    active = {song = song, index = 1, public = public, voice = C.db.voice}
    showVerse(active)
    C.player:Show()
end

function C.setVoice(enabled)
    C.db.voice = enabled
    if active then
        active.voice = enabled
        if not active.readyAt or not active.public then
            active.line = C.raceLine(active.song.verses[active.index][1], active.index, enabled)
            displayLine(active.line)
        end
    end
end

function C.sing()
    local run = active
    if not run or not run.public or run.readyAt then return end
    if C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown() then
        C.player.status:SetText("Chat restricted. Try again later.")
        return
    end
    local ok = pcall(C_ChatInfo.SendChatMessage, run.line, "SAY")
    if not ok then
        C.player.status:SetText("Chat unavailable. Click to retry.")
        return
    end
    run.readyAt = GetTime() + run.duration
    C.player.sing:Disable()
end

function C.tick()
    local run = active
    if not run or not run.readyAt then return end
    local left = math.ceil(run.readyAt - GetTime())
    if left > 0 then
        if run.lastLeft ~= left then
            run.lastLeft = left
            local label = run.index == #run.song.verses and "Finishes" or "Next verse"
            C.player.status:SetText(("Verse %d/%d  •  %s in %ds"):format(run.index, #run.song.verses, label, left))
        end
        return
    end
    if run.index == #run.song.verses then C.stop(); return end
    run.index = run.index + 1
    run.lastLeft = nil
    showVerse(run)
end
