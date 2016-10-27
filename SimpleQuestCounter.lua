local parent = WorldMapFrame.BorderFrame --WorldMapDetailFrame--WorldMapFrame
SimpleQuestCounter_Frame = CreateFrame("Frame", nil, parent)

local frame = SimpleQuestCounter_Frame

frame.counterFontString = frame:CreateFontString(nil,"ARTWORK", "GameFontHighlightSmall")
local counterFontString = frame.counterFontString

-- set string
counterFontString:SetFormattedText("Quests: ? / ?")

-- position in parent
counterFontString:SetAllPoints(true)
local verticalOffset = (-1)*3.25*counterFontString:GetHeight()
local horizontalOffset = (-1)*counterFontString:GetWidth()/1.89
counterFontString:SetPoint("TOPRIGHT", parent, "TOPRIGHT", horizontalOffset, verticalOffset)

-- font size: double than the default for the parent frame
local fontFileName, previousFontHeight, flags = counterFontString:GetFont()
local fontHeight = previousFontHeight * 2
counterFontString:SetFont(fontFileName, fontHeight, flags)

-- shadow
counterFontString:SetShadowColor(0, 0, 0, 0.75)
counterFontString:SetShadowOffset(fontHeight*0.15,-fontHeight*0.15)

frame:SetSize(counterFontString:GetWidth(),counterFontString:GetHeight())


-- on update => refresh
frame:SetScript("OnUpdate", function (self, elapsed)
        local frame = SimpleQuestCounter_Frame
        local counterFontString = frame.counterFontString
        local w = counterFontString:GetWidth()
        local h = counterFontString:GetHeight()

        local _, questsNumber = GetNumQuestLogEntries()
        counterFontString:SetFormattedText("Quests: %d / %d", questsNumber,25)
        SimpleQuestCounter_Frame:SetSize(w, h)
    end
)


frame:Show()
counterFontString:Show()


