---
-- Addon's parameters
----


local questMaxLimit = 25 -- TODO: is it provided by WOW API?
local questMaxLimitColor = { 255/255, 94/255, 0/255 } -- red/orange
local questMinLimitColor = { 255/255, 255/255, 255/255 } -- pure white
local fontTemplate = "GameFontHighlightSmall"
local fontStringDepthLevel = "ARTWORK"
local fontStringAlpha = 1 -- 0.0 (transparent) to 1.0 (opaque)
local verticalOffsetToHeightFactor = 3.25 -- TODO: maybe rework it relative to fontheight and parent size
local horizontalOffsetToWidthFactor = 1.89 -- TODO: maybe rework it relative to fontheight and parent size
local shadowColor = {0, 0, 0, 0.75} -- {r,g,b,a}
local shadowOffsetToFontHeightRatio = 0.15
local fontStringTextFormat = "Quests: %d / %d" -- TODO: localize


----
-- Functions
----


function SimpleQuestCounter_OnUpdate(self, elapsed)
    -- TODO: no need to refresh per frame
    local frame = SimpleQuestCounter_Frame
    local counterFontString = frame.counterFontString
    local w = counterFontString:GetWidth()
    local h = counterFontString:GetHeight()

    local _, questsNumber = GetNumQuestLogEntries()
    counterFontString:SetFormattedText(fontStringTextFormat, questsNumber,questMaxLimit)
    r,g,b = unpack(SimpleQuestCounter_CalculateColor(questsNumber,questMaxLimit, questMinLimitColor, questMaxLimitColor))
    counterFontString:SetTextColor(r,g,b, fontStringAlpha)
    SimpleQuestCounter_Frame:SetSize(w, h)
end



function SimpleQuestCounter_CalculateColor(questsNumber, questMaxNumber, minLimitColor, maxLimitColor)
    local result = {}
    local ratio = questsNumber / questMaxNumber
    result[1] = math.abs(minLimitColor[1] - math.abs(minLimitColor[1] - maxLimitColor[1] ) * ratio * ratio * ratio)
    result[2] = math.abs(minLimitColor[2] - math.abs(minLimitColor[2] - maxLimitColor[2] ) * ratio * ratio * ratio)
    result[3] = math.abs(minLimitColor[3] - math.abs(minLimitColor[3] - maxLimitColor[3] ) * ratio * ratio * ratio)
    return result
end


----
-- Components setup
----


-- the parent of the frame
local parent = WorldMapFrame.BorderFrame --WorldMapDetailFrame--WorldMapFrame

-- create frame
SimpleQuestCounter_Frame = CreateFrame("Frame", nil, parent)
local frame = SimpleQuestCounter_Frame

-- create font string
frame.counterFontString = frame:CreateFontString(nil, fontStringDepthLevel, fontTemplate)
local counterFontString = frame.counterFontString
counterFontString:SetTextColor(unpack(questMinLimitColor), fontStringAlpha)
counterFontString:SetFormattedText(fontStringTextFormat, 99, 99) -- default text, to calculate initial dimensions

-- position of font string in parent, relative to font string's size
counterFontString:SetAllPoints(true)
local verticalOffset = (-1) * verticalOffsetToHeightFactor * counterFontString:GetHeight()
local horizontalOffset = (-1) * counterFontString:GetWidth() / horizontalOffsetToWidthFactor
counterFontString:SetPoint("TOPRIGHT", parent, "TOPRIGHT", horizontalOffset, verticalOffset)

-- font height: double than the default for the parent frame
local fontFileName, previousFontHeight, flags = counterFontString:GetFont()
local fontHeight = previousFontHeight * 2
counterFontString:SetFont(fontFileName, fontHeight, flags)

-- shadow
counterFontString:SetShadowColor(unpack(shadowColor))
local shadowXOffset = fontHeight * shadowOffsetToFontHeightRatio
local shadowYOffset =  -fontHeight * shadowOffsetToFontHeightRatio
counterFontString:SetShadowOffset(shadowXOffset, shadowYOffset)

-- pack frame size to fontstring size
frame:SetSize(counterFontString:GetWidth(),counterFontString:GetHeight())


-- on update => refresh
frame:SetScript("OnUpdate", SimpleQuestCounter_OnUpdate)

-- show components
frame:Show()
counterFontString:Show()

