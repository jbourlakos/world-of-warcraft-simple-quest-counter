
---
-- Imports
----

local MAX_QUESTS = _G["MAX_QUESTS"]



---
-- Addon's parameters
----

-- TODO: create file-global parameter array
local questMaxLimit = MAX_QUESTS or 25
local questMaxLimitColor = { 252/255, 10/255, 10/255 } -- red
local questMidLimitColor = { 255/255, 255/255, 0/255} -- yellow
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
local tooltipTitle = "Quests per category" -- TODO: localize
local tooltipLineFormat = "%s |ce0dddd00(%d)|r" -- header (count)
local tooltipLineColor = {1, 1, 1} -- white



----
-- Context
----

local tooltipObject = WorldMapTooltip or GameTooltip
local worldMapSizedUp = (WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE)
hooksecurefunc("WorldMap_ToggleSizeUp", function() 
    worldMapSizedUp = true
end)
hooksecurefunc("WorldMap_ToggleSizeDown", function()
    worldMapSizedUp = false
end)


----
-- Functions
----

function SimpleQuestCounter_OnClick(self, button)
    if (button == "LeftButton") then
         -- SimpleQuestCounter_OnLeftClick(self,button)
         -- skip: TODO fix
    elseif (button == "RightButton") then
        SimpleQuestCounter_OnRightClick(self,button)
    end
end



function SimpleQuestCounter_OnLeftClick(self,button)
    if (worldMapSizedUp) then
        WorldMapFrame_ToggleWindowSize()
        worldMapSizedUp = false
    else
        WorldMap_ToggleSizeUp()
        worldMapSizedUp = true
    end
end



function SimpleQuestCounter_OnRightClick(self,button)

    tooltipObject:Hide()

    local function AddQuestCountPerHeader()
        countPerHeader = {}
        currentHeader = nil
        for i = 1, GetNumQuestLogEntries(), 1 do
            qTitle, qLevel, qGroup, qIsHeader, qIsCollapsed, qIsComplete, freq, qId, _, _, _, _, qIsTask, _  = GetQuestLogTitle(i)
            if (qIsHeader) then
                currentHeader = qTitle
                if countPerHeader[currentHeader] == nil then -- a header might appear more than once
                    countPerHeader[currentHeader] = 0
                end
            elseif (not qIsHeader and not qIsTask) then
                countPerHeader[currentHeader] = countPerHeader[currentHeader] + 1
            end
        end
        for header, count in pairs(countPerHeader) do
            tooltipObject:AddLine(string.format(tooltipLineFormat, header, count), unpack(tooltipLineColor))
        end
    end

    tooltipObject:SetOwner(self, "ANCHOR_CURSOR")
    tooltipObject:SetText(tooltipTitle)
    AddQuestCountPerHeader()
    tooltipObject:Show()
end


function SimpleQuestCounter_OnEnter(self)
    tooltipObject:Hide() -- in case other tooltip appears
    tooltipObject:SetOwner(self, "ANCHOR_CURSOR")
    tooltipObject:SetText(tooltipTitle)
    tooltipObject:AddLine("Right click for more information")
    tooltipObject:Show()
end



function SimpleQuestCounter_OnLeave(self)
    tooltipObject:Hide()
end



function SimpleQuestCounter_OnUpdate(self, elapsed)
    -- TODO: no need to refresh per frame
    local frame = SimpleQuestCounter_Frame
    local counterFontString = frame.counterFontString
    local w = counterFontString:GetWidth()
    local h = counterFontString:GetHeight()

    local _, questsNumber = GetNumQuestLogEntries()
    counterFontString:SetFormattedText(fontStringTextFormat, questsNumber,questMaxLimit)
    local colorScale = questsNumber / questMaxLimit
    r,g,b = unpack(SimpleQuestCounter_CalculateColor(colorScale, questMinLimitColor, questMidLimitColor, questMaxLimitColor))
    counterFontString:SetTextColor(r,g,b, fontStringAlpha)
    SimpleQuestCounter_Frame:SetSize(w, h)
end



function SimpleQuestCounter_CalculateColor(colorScale, minLimitColor, midLimitColor, maxLimitColor)
    local result = {}
    local startColor = minLimitColor
    local endColor = maxLimitColor
    
    if (colorScale <= 0.5) then
        endColor = midLimitColor
        colorScale = colorScale + 0.5 -- scale correction
    else
        startColor = midLimitColor
        colorScale = colorScale - 0.5
    end
    colorScale = colorScale * colorScale
    -- for each color component, 1 -> r, 2 -> g, 3 -> b, 
    for i=1,3,1 do
        result[i] = startColor[i] + (endColor[i]-startColor[i]) * colorScale
    end

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


-- enable mouse
frame:EnableMouse(true)


-- on update => refresh
frame:SetScript("OnUpdate", SimpleQuestCounter_OnUpdate)
frame:SetScript("OnEnter", SimpleQuestCounter_OnEnter)
frame:SetScript("OnLeave", SimpleQuestCounter_OnLeave)
frame:SetScript("OnMouseUp", SimpleQuestCounter_OnClick)

-- show components
frame:Show()
counterFontString:Show()

