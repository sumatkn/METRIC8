local addonName, addon = ...

local function hideUnspentTalentTip()
    local message = TALENT_MICRO_BUTTON_UNSPENT_TALENTS
    if type(message) == "string" and message ~= "" then
        HelpTip:HideAllSystem("MicroButtons", message)
    end
end

function addon.SetBlockUnspentTalents(enabled)
    METRIC8_NoTHXDB.blockUnspentTalents = enabled
    if enabled then
        hideUnspentTalentTip()
    end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, _, loadedName)
    if loadedName ~= addonName then return end
    self:UnregisterEvent("ADDON_LOADED")

    if type(METRIC8_NoTHXDB) ~= "table" then
        METRIC8_NoTHXDB = {}
    end
    if type(METRIC8_NoTHXDB.blockUnspentTalents) ~= "boolean" then
        METRIC8_NoTHXDB.blockUnspentTalents = true
    end

    -- Blizzard records the active alert after HelpTip:Show returns. Closing
    -- after ShowAlert lets its normal close callback clear that active state.
    hooksecurefunc("MainMenuMicroButton_ShowAlert", function(button, text)
        if METRIC8_NoTHXDB.blockUnspentTalents and button == TalentMicroButton
            and text == TALENT_MICRO_BUTTON_UNSPENT_TALENTS then
            hideUnspentTalentTip()
        end
    end)

    if METRIC8_NoTHXDB.blockUnspentTalents then
        hideUnspentTalentTip()
    end
end)
