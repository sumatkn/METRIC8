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

local sending, blockedAction

-- A protected call can raise a client event without throwing a Lua error.
local restrictions = CreateFrame("Frame")
restrictions:RegisterEvent("ADDON_ACTION_BLOCKED")
restrictions:RegisterEvent("ADDON_ACTION_FORBIDDEN")
restrictions:SetScript("OnEvent", function(_, event, addon, action)
    if addon ~= "METRIC8_CampCant" then return end
    print("CampCant: " .. event .. " (" .. tostring(action) .. ")")
    if sending then blockedAction = true end
end)

function C.sing()
    local run = active
    if not run or run.index >= #run.song.verses then return end
    local index = run.index + 1
    local line = C.raceLine(run.song.verses[index][1], index, C.db.voice)
    displayLine(line)
    local mode = "Rehearsal"
    if run.public then
        if run.useChatBox then
            if ChatFrameUtil.GetActiveWindow() then
                C.player.status:SetText("Send or close the open chat entry first.")
                return
            end
            ChatFrameUtil.OpenChat("/say " .. line, DEFAULT_CHAT_FRAME)
            mode = "Press Enter in chat"
        else
            local restricted = C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown()
            local ok, reason
            if not restricted then
                sending, blockedAction = true, false
                ok, reason = pcall(C_ChatInfo.SendChatMessage, line, "SAY")
                sending = false
            end
            if restricted or not ok or blockedAction then
                if reason then print("CampCant /say: " .. tostring(reason)) end
                run.useChatBox = true
                C.player.status:SetText("Click Next Verse to put this line in chat.")
                return
            end
            mode = "/say"
        end
    end
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
