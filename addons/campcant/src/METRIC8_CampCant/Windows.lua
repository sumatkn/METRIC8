local _, C = ...
local book, editor
local selected, page = 1, 1
local draft, editing, editPage

local function panel(name, width, height, offset)
    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:SetSize(width, height)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, offset)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 18,
        insets = {left=4, right=4, top=4, bottom=4}})
    f:SetFrameStrata("DIALOG")
    f:Hide()
    return f
end

local function label(parent, x, y, width, font)
    local t = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    t:SetPoint("TOPLEFT", x, -y)
    t:SetWidth(width)
    t:SetJustifyH("LEFT")
    t:SetNonSpaceWrap(true)
    return t
end

local function button(parent, x, y, width, caption, fn)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(width, 24)
    b:SetPoint("TOPLEFT", x, -y)
    b:SetText(caption)
    b:SetScript("OnClick", fn)
    return b
end

local function field(parent, x, y, width, height, multi)
    local e = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
    e:SetSize(width, height)
    e:SetPoint("TOPLEFT", x, -y)
    e:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8"})
    e:SetBackdropColor(0.12, 0.12, 0.12, 1)
    e:SetFontObject(GameFontHighlight)
    e:SetAutoFocus(false)
    e:SetMultiLine(multi or false)
    e:SetTextInsets(6, 6, 4, 4)
    e:SetScript("OnEscapePressed", e.ClearFocus)
    e:SetScript("OnEnterPressed", e.ClearFocus)
    return e
end

local function songAt(i)
    return C.builtins[i] or C.db.songs[i - #C.builtins]
end

local function refresh()
    local song = songAt(selected)
    local total = #C.builtins + #C.db.songs
    book.title:SetText(song.title)
    book.credit:SetText(song.credit or "Your songbook")
    book.index:SetText(("Song %d of %d"):format(selected, total))
    book.prev:SetEnabled(selected > 1)
    book.next:SetEnabled(selected < total)
    book.line:SetText(C.raceLine(song.verses[page][1], page, C.db.voice))
    book.page:SetText(("Verse %d / %d"):format(page, #song.verses))
    book.back:SetEnabled(page > 1)
    book.forward:SetEnabled(page < #song.verses)

    book.edit:SetText(selected <= #C.builtins and "Edit a copy" or "Edit song")
end

local function selectSong(delta)
    selected, page = selected + delta, 1
    refresh()
end

local function commitFields()
    draft.title = C.clean(editor.title:GetText())
    draft.verses[editPage] = {C.clean(editor.line:GetText())}
end

local function editView()
    local verse = draft.verses[editPage]
    editor.title:SetText(draft.title)
    editor.line:SetText(verse[1])
    editor.index:SetText(("Verse %d of %d"):format(editPage, #draft.verses))
    editor.prev:SetEnabled(editPage > 1)
    editor.next:SetEnabled(editPage < #draft.verses)
    editor.remove:SetEnabled(#draft.verses > 1)
    editor.feedback:SetText("")
end

local function openEditor(copy)
    local source = copy and songAt(selected)
    editing = source and selected > #C.builtins and selected - #C.builtins or nil
    draft = {title = source and source.title or "", verses = {}}
    if source then
        for i, v in ipairs(source.verses) do draft.verses[i] = {v[1]} end
        if not editing then draft.title = draft.title .. " (my version)" end
    else
        draft.verses[1] = {""}
    end
    editPage = 1
    book:Hide()
    editView()
    editor:Show()
    if not source then editor.title:SetFocus() end
end

local function finishEdit()
    editor:Hide()
    draft = nil
    refresh()
    book:Show()
end

local function save()
    commitFields()
    local err = C.validate(draft)
    if err then editor.feedback:SetText(err); return end
    local index = editing or #C.db.songs + 1
    C.db.songs[index] = draft
    selected, page = #C.builtins + index, 1
    finishEdit()
end

local function play(public)
    book:Hide()
    C.stop()
    C.player:Show()
    if not public then C.start(songAt(selected), false) end
end

local function build()
    book = panel("METRIC8_CampCantBook", 460, 306, 0)
    table.insert(UISpecialFrames, "METRIC8_CampCantBook")
    label(book, 16, 14, 300, "GameFontNormalLarge"):SetText("METRIC8: CampCant")
    button(book, 390, 10, 54, "Close", function() play(true) end)
    book.prev = button(book, 16, 44, 40, "<", function() selectSong(-1) end)
    book.next = button(book, 60, 44, 40, ">", function() selectSong(1) end)
    book.index = label(book, 110, 50, 122)
    button(book, 245, 44, 94, "New song", function() openEditor(false) end)
    book.edit = button(book, 344, 44, 100, "Edit song", function() openEditor(true) end)
    book.title = label(book, 16, 81, 430, "GameFontNormalLarge")
    book.credit = label(book, 16, 106, 430, "GameFontDisableSmall")
    book.line = label(book, 16, 136, 426)
    book.back = button(book, 16, 214, 34, "<", function() page=page-1; refresh() end)
    book.page = label(book, 60, 220, 104)
    book.forward = button(book, 170, 214, 34, ">", function() page=page+1; refresh() end)
    button(book, 16, 260, 132, "Rehearse privately", function() play(false) end)
    button(book, 158, 260, 132, "Select song", function() play(true) end)

    editor = panel("METRIC8_CampCantEditor", 460, 288, 0)
    label(editor, 16, 14, 400, "GameFontNormalLarge"):SetText("Edit song")
    label(editor, 16, 46, 70):SetText("Title")
    editor.title = field(editor, 80, 40, 364, 27)
    editor.title:SetMaxLetters(46)
    editor.index = label(editor, 16, 86, 122)
    local function step(delta) commitFields(); editPage = editPage + delta; editView() end
    editor.prev = button(editor, 140, 78, 36, "<", function() step(-1) end)
    editor.next = button(editor, 180, 78, 36, ">", function() step(1) end)
    button(editor, 225, 78, 98, "Add verse", function()
        commitFields()
        editPage = editPage + 1
        table.insert(draft.verses, editPage, {""})
        editView()
        editor.line:SetFocus()
    end)
    editor.remove = button(editor, 328, 78, 116, "Remove verse", function()
        commitFields()
        table.remove(draft.verses, editPage)
        editPage = math.min(editPage, #draft.verses)
        editView()
    end)
    editor.line = field(editor, 16, 112, 428, 84, true)
    editor.line:SetMaxLetters(255)
    editor.feedback = label(editor, 16, 205, 428, "GameFontNormal")
    button(editor, 16, 242, 102, "Save song", save)
    button(editor, 125, 242, 134, "Discard edits", finishEdit)

    local p = panel("METRIC8_CampCantPlayer", 316, 104, -150)
    p:ClearAllPoints()
    p:SetPoint("TOP", UIParent, "CENTER", 0, -98)
    C.player = p
    p.title = button(p, 12, 8, 260, "", function()
        C.stop()
        p:Hide()
        refresh()
        book:Show()
    end)
    p.title:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Open songbook")
        GameTooltip:Show()
    end)
    p.title:SetScript("OnLeave", function() GameTooltip:Hide() end)
    button(p, 276, 8, 28, "×", function() C.stop(); p:Hide() end)
    p.voice = CreateFrame("CheckButton", nil, p, "UICheckButtonTemplate")
    p.voice:SetSize(25, 25)
    p.voice:SetPoint("TOPLEFT", 13, -36)
    label(p, 42, 42, 252):SetText("Use racial cadence / accent")
    p.voice:SetHitRectInsets(0, -200, 0, 0)
    p.voice:SetScript("OnClick", function(self) C.setVoice(self:GetChecked() and true or false) end)
    p.start = button(p, 12, 68, 84, "Start", function()
        C.start(songAt(selected), true)
    end)
    p.sing = button(p, 101, 68, 110, "Next Verse", C.sing)
    p.stop = button(p, 216, 68, 88, "Stop", C.stop)
    p.line = label(p, 14, 102, 288)
    p.status = label(p, 14, 183, 288, "GameFontNormalSmall")
    p:RegisterEvent("PLAYER_LEAVING_WORLD")
    p:SetScript("OnEvent", function() C.stop(); p:Hide() end)
    C.showIdle()
end

function C.showIdle()
    local p = C.player
    p:SetHeight(104)
    p.title:SetText(songAt(selected).title)
    p.voice:SetChecked(C.db.voice == true)
    p.line:SetText("")
    p.status:SetText("")
    p.start:Enable()
    p.sing:Disable()
    p.stop:Disable()
end

SLASH_METRIC8CAMPCANT1 = "/campcant"
SlashCmdList.METRIC8CAMPCANT = function(arg)
    if C.clean(arg or ""):lower() == "stop" then C.stop(); return end
    if not book then build() end
    if editor:IsShown() then return end
    if book:IsShown() then play(true); return end
    if C.player:IsShown() then C.stop(); C.player:Hide() else C.player:Show() end
end
