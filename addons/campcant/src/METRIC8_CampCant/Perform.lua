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

function C.sing()
    local run = active
    if not run or run.index >= #run.song.verses then return end
    local index = run.index + 1
    local line = C.raceLine(run.song.verses[index][1], index, C.db.voice)
    local mode = "Rehearsal"
    if run.public then
        if ChatFrameUtil.GetActiveWindow() then
            C.player.status:SetText("Send or close the open chat entry first.")
            return
        end
        -- Let the player's Enter key submit the line through Blizzard chat.
        ChatFrameUtil.OpenChat("/say " .. line, DEFAULT_CHAT_FRAME)
        mode = "Press Enter in chat"
    end
    displayLine(line)
    run.index = index
    C.player.sing:SetEnabled(index < #run.song.verses)
    C.player.status:SetText(("Verse %d/%d  •  %s"):format(index, #run.song.verses, mode))
end

function C.start(song, public)
    if C.validate(song) then return end
    active = {song = song, public = public, index = 0}
    C.player.start:Disable()
    C.player.stop:Enable()
    C.player.sing:Enable()
    C.player.title:SetText(song.title)
    C.player:Show()
    C.sing()
end

function C.setVoice(enabled)
    C.db.voice = enabled
    if active and not active.public and active.index > 0 then
        displayLine(C.raceLine(active.song.verses[active.index][1], active.index, enabled))
    end
end
