---
-- Addon's parameters
----


local questMaxLimit = 25 -- TODO: is it provided by WOW API?
local questMaxLimitColor = { 252/255, 76/255, 2/255 } -- red/orange
local questMinLimitColor = { 255/255, 255/255, 255/255 } -- pure white
local fontTemplate = "GameFontHighlightSmall"
local fontStringDepthLevel = "ARTWORK"
local fontStringAlpha = 1 -- 0.0 (transparent) to 1.0 (opaque)
local verticalOffsetToHeightFactor = 1.9 
local horizontalOffsetToWidthFactor = 0.15
local shadowColor = {0, 0, 0, 0.75} -- {r,g,b,a}
local shadowOffsetToFontHeightRatio = 0.15
local fontStringTextFormat = "Quests: %d / %d" -- TODO: localize
local fontSizeAdjustment = 1.75 -- multiplier relative to parent's default font size


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
    ration = ratio * ratio * ratio -- cubic scale
    result[1] = math.abs(minLimitColor[1] - math.abs(minLimitColor[1] - maxLimitColor[1] ) * ratio)
    result[2] = math.abs(minLimitColor[2] - math.abs(minLimitColor[2] - maxLimitColor[2] ) * ratio)
    result[3] = math.abs(minLimitColor[3] - math.abs(minLimitColor[3] - maxLimitColor[3] ) * ratio)
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

-- position of font string in frame
counterFontString:SetPoint("CENTER", frame, "CENTER", 0, 0)

-- font height: relative to the default of the parent frame
local fontFileName, previousFontHeight, flags = counterFontString:GetFont()
local fontHeight = previousFontHeight * fontSizeAdjustment
counterFontString:SetFont(fontFileName, fontHeight, flags)

-- shadow
counterFontString:SetShadowColor(unpack(shadowColor))
local shadowXOffset = fontHeight * shadowOffsetToFontHeightRatio
local shadowYOffset =  -fontHeight * shadowOffsetToFontHeightRatio
counterFontString:SetShadowOffset(shadowXOffset, shadowYOffset)

-- position frame to parent, relative to font size
local toprightHorizontalOffset = counterFontString:GetWidth() * horizontalOffsetToWidthFactor
local toprightVerticalOffset = counterFontString:GetHeight() * verticalOffsetToHeightFactor
frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -toprightHorizontalOffset, -toprightVerticalOffset)


-- on update => refresh
frame:SetScript("OnUpdate", SimpleQuestCounter_OnUpdate)

-- show components
frame:Show()
counterFontString:Show()

