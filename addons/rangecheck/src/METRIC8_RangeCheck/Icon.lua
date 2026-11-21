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

local sightPanel = frame:CreateTexture(nil, "OVERLAY", nil, 1)
sightPanel:SetPoint("TOPRIGHT")
sightPanel:SetSize(33, 15)
sightPanel:SetColorTexture(0.52, 0.06, 0.04, 1)
local sightBadge = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall", 2)
sightBadge:SetPoint("CENTER", sightPanel)
sightBadge:SetText("LOS!")
sightBadge:SetTextColor(1, 1, 1)

function addon.ShowSightWarning(visible)
    sightPanel:SetShown(visible)
    sightBadge:SetShown(visible)
end
addon.ShowSightWarning(false)

local distanceLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
distanceLabel:SetPoint("TOP", frame, "BOTTOM", 0, -3)
distanceLabel:SetShadowColor(0, 0, 0, 1)
distanceLabel:SetShadowOffset(1, -1)

function addon.ShowDistance(text)
    distanceLabel:SetText(text)
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
