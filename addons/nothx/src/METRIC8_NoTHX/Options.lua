local _, addon = ...
local window

local function createOptions()
    local frame = CreateFrame("Frame", "METRIC8_NoTHXOptions", UIParent, "BackdropTemplate")
    frame:SetSize(300, 98)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 20,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -14)
    title:SetText("METRIC8: NoTHX")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -3, -3)
    close:SetScript("OnClick", function() frame:Hide() end)

    local check = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    check:SetPoint("TOPLEFT", 13, -46)
    local label = check:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("LEFT", check, "RIGHT", 1, 0)
    label:SetText("Block unspent talent reminder")
    check:SetHitRectInsets(0, -label:GetStringWidth() - 1, 0, 0)
    check:SetScript("OnClick", function(self)
        addon.SetBlockUnspentTalents(self:GetChecked() and true or false)
    end)
    frame:SetScript("OnShow", function()
        check:SetChecked(METRIC8_NoTHXDB.blockUnspentTalents)
    end)
    frame:Hide()
    table.insert(UISpecialFrames, "METRIC8_NoTHXOptions")
    return frame
end

SLASH_METRIC8NOTHX1 = "/nothx"
SlashCmdList.METRIC8NOTHX = function()
    window = window or createOptions()
    window:SetShown(not window:IsShown())
end
