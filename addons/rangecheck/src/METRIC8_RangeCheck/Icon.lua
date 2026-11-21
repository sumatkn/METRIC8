local _, addon = ...

local frame = CreateFrame("Frame", "METRIC8_RangeCheckIcon", UIParent)
frame:SetSize(48, 48)
frame:SetMovable(true)
frame:SetClampedToScreen(true)

local artwork = frame:CreateTexture(nil, "ARTWORK")
artwork:SetAllPoints()
local overlay = frame:CreateTexture(nil, "OVERLAY")
overlay:SetAllPoints()
local strip = frame:CreateTexture(nil, "OVERLAY", nil, 1)
strip:SetPoint("BOTTOMLEFT")
strip:SetPoint("BOTTOMRIGHT")
strip:SetHeight(15)
strip:SetColorTexture(0, 0, 0, 0.85)
local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall", 2)
label:SetPoint("CENTER", strip)

local sightBadge = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall", 2)
sightBadge:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
sightBadge:SetText("LOS!")
sightBadge:SetTextColor(1, 0.4, 0.30)
sightBadge:Hide()

function addon.ShowSightWarning(visible)
    sightBadge:SetShown(visible)
end

local dragProfile
local function finishDrag()
    if not dragProfile then return end
    frame:StopMovingOrSizing()
    local x, y = frame:GetCenter()
    local centerX, centerY = UIParent:GetCenter()
    if x and y and centerX and centerY then
        dragProfile.x = x * frame:GetScale() - centerX
        dragProfile.y = y * frame:GetScale() - centerY
    end
    dragProfile = nil
end

frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function()
    dragProfile = addon.ActiveProfile()
    frame:StartMoving()
end)
frame:SetScript("OnDragStop", function()
    finishDrag()
    addon.ApplyProfile()
end)

function addon.PlaceIcon(profile)
    finishDrag()
    frame:EnableMouse(not profile.locked)
    frame:SetScale(profile.scale)
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", profile.x / profile.scale, profile.y / profile.scale)
end

function addon.RenderIcon(theme, mode, status)
    local style = theme.styles[status]
    if mode == "auto" then mode = theme.mode end
    artwork:SetTexture(mode == "replace" and style.icon or theme.icon)
    overlay:SetTexture(mode == "overlay" and style.overlay or nil)
    label:SetText(style.label)
    label:SetTextColor(unpack(style.color))
end
