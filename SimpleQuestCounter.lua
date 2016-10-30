local questMaxLimit = 25
local questMaxLimitColor = { 255/255, 94/255, 0/255} -- red/orange
local questMinLimitColor = { 255/255, 255/255, 255/255} -- pure white

----
----


local parent = WorldMapFrame.BorderFrame --WorldMapDetailFrame--WorldMapFrame
SimpleQuestCounter_Frame = CreateFrame("Frame", nil, parent)

local frame = SimpleQuestCounter_Frame

frame.counterFontString = frame:CreateFontString(nil,"ARTWORK", "GameFontHighlightSmall")
local counterFontString = frame.counterFontString
counterFontString:SetTextColor(unpack(questMinLimitColor),1)
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
    -- TODO: no need to refresh per frame
        local frame = SimpleQuestCounter_Frame
        local counterFontString = frame.counterFontString
        local w = counterFontString:GetWidth()
        local h = counterFontString:GetHeight()

        local _, questsNumber = GetNumQuestLogEntries()
        counterFontString:SetFormattedText("Quests: %d / %d", questsNumber,questMaxLimit)
        r,g,b = unpack(SimpleQuestCounter_calculateColor(questsNumber,questMaxLimit, questMinLimitColor, questMaxLimitColor))
        counterFontString:SetTextColor(r,g,b,1)
        SimpleQuestCounter_Frame:SetSize(w, h)
    end
)


frame:Show()
counterFontString:Show()

----
----

function SimpleQuestCounter_calculateColor(questsNumber, questMaxNumber, minLimitColor, maxLimitColor)
    local result = {0,0,0}
    local ratio = questsNumber / questMaxNumber
    result[1] = math.abs(minLimitColor[1] - math.abs(minLimitColor[1] - maxLimitColor[1] ) * ratio * ratio * ratio)
    result[2] = math.abs(minLimitColor[2] - math.abs(minLimitColor[2] - maxLimitColor[2] ) * ratio * ratio * ratio)
    result[3] = math.abs(minLimitColor[3] - math.abs(minLimitColor[3] - maxLimitColor[3] ) * ratio * ratio * ratio)
    return result
end
