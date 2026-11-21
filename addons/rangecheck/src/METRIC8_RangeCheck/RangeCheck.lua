local _, addon = ...
local events = CreateFrame("Frame")
local class, profile, lastStatus

local function update()
    local status = addon.GetRangeStatus(class)
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

local function message(line)
    print("RangeCheck: " .. line)
end

local function options(input)
    local command, value = input:lower():match("^%s*(%S*)%s*(.-)%s*$")
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
        message("/rangecheck unlock | lock [inherit] | resetpos | scale <0.5-2|inherit> | mode <auto|overlay|replace|inherit>")
        message("/rangecheck override <on|off> | [global|class|char] theme <id|inherit>")
        return
    end
    applyProfile()
end

events:RegisterEvent("PLAYER_LOGIN")
events:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        class = addon.GetPlayerClass()
        addon.LoadProfiles(class)
        addon.ApplyProfile = applyProfile
        SLASH_METRIC8_RANGECHECK1 = "/rangecheck"
        SlashCmdList.METRIC8_RANGECHECK = options
        self:UnregisterEvent(event)
        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
        self:RegisterEvent("SPELLS_CHANGED")
        self:RegisterEvent("PLAYER_REGEN_DISABLED")
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        self:SetScript("OnUpdate", function(frame, elapsed)
            frame.elapsed = (frame.elapsed or 0) + elapsed
            if frame.elapsed >= 0.2 then
                frame.elapsed = 0
                update()
            end
        end)
        applyProfile()
    else
        update()
    end
end)
