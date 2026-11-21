local addonName, addon = ...
local events = CreateFrame("Frame")
local class, profile, lastStatus, lastDistance
local sightWarning = 0
local debugging, lastDebugOutput = false, nil

local function message(line)
    print("RangeCheck: " .. line)
end

local function clearSightWarning()
    sightWarning = 0
    addon.ShowSightWarning(false)
end

local function noteError(errorText)
    if issecretvalue and issecretvalue(errorText) then return end
    if type(errorText) ~= "string" or errorText == "" then return end
    if errorText == SPELL_FAILED_LINE_OF_SIGHT or errorText == ERR_LINE_OF_SIGHT then
        if debugging and sightWarning <= 0 then message("debug | WoW reported a line-of-sight error") end
        sightWarning = 3
        addon.ShowSightWarning(true)
    end
end

local function update()
    local details = debugging and {} or nil
    local status, spellID = addon.GetRangeStatus(class, details)
    local distance = addon.GetDistanceText(status, spellID)
    if distance ~= lastDistance then
        lastDistance = distance
        addon.ShowDistance(distance)
    end
    if details then
        local output = table.concat(details, " | ")
        if output ~= "" then output = " | " .. output end
        output = status .. output
        if output ~= lastDebugOutput then
            lastDebugOutput = output
            message("debug | " .. output)
        end
    end
    if status ~= lastStatus then
        lastStatus = status
        addon.RenderIcon(addon.GetTheme(profile.theme), profile.mode, status)
    end
end

local function applyProfile()
    profile = addon.ResolveProfile()
    addon.PlaceIcon(profile)
    lastStatus = nil
    update()
end

local function options(input)
    local command, value = input:lower():match("^%s*(%S*)%s*(.-)%s*$")
    if command == "debug" and (value == "on" or value == "off") then
        debugging = value == "on"
        lastDebugOutput = nil
        message("debug " .. value)
        if debugging then update() end
        return
    end
    if command == "status" then
        local details = {}
        local status = addon.GetRangeStatus(class, details)
        local version = C_AddOns.GetAddOnMetadata(addonName, "Version")
        message((version or "unknown version") .. " | " .. (class or "unknown class") .. " | " .. status)
        if #details > 0 then message(table.concat(details, " | ")) end
        return
    end
    local target = addon.ActiveProfile()
    if command == "global" or command == "class" or command == "char" then
        if command == "global" then target = addon.global end
        if command == "class" then target = addon.classProfile end
        if command == "char" then target = addon.character end
        command, value = value:match("^(%S*)%s*(.-)%s*$")
    end

    if command == "theme" then
        if value == "inherit" then
            target.theme = nil
        elseif addon.HasTheme(value) then
            target.theme = value
        else
            message("Choose a registered theme ID (default is bundled), or use 'theme inherit'.")
            return
        end
    elseif target == addon.global then
        message("Global settings support 'theme <id|inherit>'.")
        return
    elseif command == "override" and (value == "on" or value == "off") then
        addon.character.enabled = value == "on"
    elseif command == "scale" then
        if value == "inherit" then
            target.scale = nil
        else
            local scale = tonumber(value)
            if not scale or not (scale >= 0.5 and scale <= 2) then
                message("Scale must be between 0.5 and 2, or 'inherit'.")
                return
            end
            target.scale = scale
        end
    elseif command == "lock" and value == "inherit" then
        target.locked = nil
    elseif (command == "lock" or command == "unlock") and value == "" then
        target.locked = command == "lock"
    elseif command == "resetpos" then
        target.x, target.y = nil, nil
    elseif command == "mode" and (value == "auto" or value == "overlay" or value == "replace" or value == "inherit") then
        if value == "inherit" then target.mode = nil else target.mode = value end
    else
        message("/rangecheck status | debug <on|off> | unlock | lock [inherit] | resetpos | scale <0.5-2|inherit> | mode <auto|overlay|replace|inherit>")
        message("/rangecheck override <on|off> | [global|class|char] theme <id|inherit>")
        return
    end
    applyProfile()
end

events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(self, event, first, second, third)
    if event == "PLAYER_LOGIN" then
        class = addon.GetPlayerClass()
        addon.LoadProfiles(class)
        addon.ApplyProfile = applyProfile
        SLASH_METRIC8_RANGECHECK1 = "/rangecheck"
        SlashCmdList.METRIC8_RANGECHECK = options
        self:UnregisterEvent(event)
        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        if class == "HUNTER" then
            self:RegisterEvent("PLAYER_SWING_RANGE_UPDATE")
            self:RegisterEvent("PLAYER_ENTERING_WORLD")
        end
        self:RegisterEvent("UI_ERROR_MESSAGE")
        self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
        self:RegisterEvent("SPELLS_CHANGED")
        self:RegisterEvent("PLAYER_REGEN_DISABLED")
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        self:SetScript("OnUpdate", function(frame, elapsed)
            if sightWarning > 0 then
                sightWarning = sightWarning - elapsed
                if sightWarning <= 0 then clearSightWarning() end
            end
            frame.elapsed = (frame.elapsed or 0) + elapsed
            if frame.elapsed >= 0.2 then
                frame.elapsed = 0
                update()
            end
        end)
        applyProfile()
    elseif event == "UI_ERROR_MESSAGE" then
        noteError(second)
    elseif event == "PLAYER_SWING_RANGE_UPDATE" then
        addon.NoteSwingRange(first, second, third)
        update()
    else
        if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
            addon.ClearMainHandEvent()
        end
        if event == "PLAYER_TARGET_CHANGED" then
            clearSightWarning()
            lastDebugOutput = nil
        end
        update()
    end
end)
