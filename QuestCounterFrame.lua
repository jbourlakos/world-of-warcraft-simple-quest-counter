if not QuestScrollFrame then return end
if not QuestScrollFrame.Background then return end
if not QuestScrollFrame.ScrollBar then return end
if not WorldMapFrame then return end
if not WorldMapFrame.BorderFrame then return end
if not WorldMapTooltip and not GameTooltip then return end

local Settings = SimpleQuestCounter.Settings
local Context = SimpleQuestCounter.Context

----
-- QuestCounterFrame
----

SimpleQuestCounter.QuestCounterFrame = {}
local QuestCounterFrame = SimpleQuestCounter.QuestCounterFrame



QuestCounterFrame.TooltipObject = WorldMapTooltip or GameTooltip



QuestCounterFrame.Frame = CreateFrame("Frame", nil, WorldMapFrame.BorderFrame)



function QuestCounterFrame:OnClick(button)
    if (button == "LeftButton") then
        -- do nothing
    elseif (button == "RightButton") then
        -- do nothing
    end
end



function QuestCounterFrame:OnLeftClick(button)
    -- do nothing
end



function QuestCounterFrame:OnRightClick(button)
    -- do nothing
end



function QuestCounterFrame.OnEnter()

    -- do nothing

    -- TODO: cleanup

    -- local tooltipTitle = Settings.tooltipTitle

    -- self.TooltipObject:Hide() -- in case other tooltip appears
    -- self.TooltipObject:SetOwner(self, "ANCHOR_CURSOR")
    -- self.TooltipObject:SetText(tooltipTitle)
    -- self.TooltipObject:AddLine("Right click for more information") -- TODO: refactor / localize
    -- self.TooltipObject:Show()

end



function QuestCounterFrame:OnLeave()
    -- do nothing

    -- TODO: cleanup
    -- self.TooltipObject:Hide()
end



function QuestCounterFrame:OnUpdate(elapsed)

    local questMaxLimit = Context.maxQuests
    local fontStringTextFormat = Settings.fontStringTextFormat
    local questMinLimitColor = Settings.questMinLimitColor
    local questMidLimitColor = Settings.questMidLimitColor
    local questMaxLimitColor = Settings.questMaxLimitColor
    local fontStringAlpha = Settings.fontStringAlpha

    -- TODO: no need to refresh per frame
    local frame = QuestCounterFrame.Frame
    local counterFontString = frame.counterFontString
    local w = counterFontString:GetWidth()
    local h = counterFontString:GetHeight()

    local _, questsNumber = GetNumQuestLogEntries()
    counterFontString:SetFormattedText(fontStringTextFormat, questsNumber,questMaxLimit)
    local colorScale = questsNumber / questMaxLimit
    local r,g,b = unpack(QuestCounterFrame:CalculateColor(colorScale, questMinLimitColor, questMidLimitColor, questMaxLimitColor))
    counterFontString:SetTextColor(r,g,b, fontStringAlpha)
    frame:SetSize(w, h)

end



function QuestCounterFrame:CalculateColor(colorScale, minLimitColor, midLimitColor, maxLimitColor)
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

local questMinLimitColor = Settings.questMinLimitColor
local fontStringAlpha = Settings.fontStringAlpha
local fontTemplate = Settings.fontTemplate
local fontStringTextFormat = Settings.fontStringTextFormat
local fontSizeAdjustment = Settings.fontSizeAdjustment
local shadowColor = Settings.shadowColor
local shadowOffsetToFontHeightRatio = Settings.shadowOffsetToFontHeightRatio
local horizontalOffsetToWidthFactor = Settings.horizontalOffsetToWidthFactor
local verticalOffsetToHeightFactor = Settings.verticalOffsetToHeightFactor


-- the parent of the frame
local parent = WorldMapFrame.BorderFrame --WorldMapDetailFrame--WorldMapFrame

-- create frame
local frame = QuestCounterFrame.Frame

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
frame:SetScript("OnUpdate", QuestCounterFrame.OnUpdate)
frame:SetScript("OnEnter", QuestCounterFrame.OnEnter)
frame:SetScript("OnLeave", QuestCounterFrame.OnLeave)
frame:SetScript("OnMouseUp", QuestCounterFrame.OnClick)

-- TODO: monkey fix
QuestScrollFrame:ClearAllPoints()
QuestScrollFrame:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -counterFontString:GetHeight())
QuestScrollFrame:SetPoint("BOTTOMLEFT", WorldMapFrame.ScrollContainer, "BOTTOMRIGHT", 0, 0)
QuestScrollFrame:SetPoint("BOTTOMRIGHT", WorldMapFrame.BorderFrame, "BOTTOMRIGHT", -5, 0)

QuestScrollFrame.ScrollBar:ClearAllPoints();
QuestScrollFrame.ScrollBar:SetPoint("TOPLEFT", QuestScrollFrame, "TOPRIGHT", 0, -QuestScrollFrame.ScrollBar.ScrollUpButton:GetHeight())
QuestScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", WorldMapFrame.BorderFrame, "BOTTOMRIGHT", -10, QuestScrollFrame.ScrollBar.ScrollDownButton:GetHeight())

QuestScrollFrame.Background:ClearAllPoints()
QuestScrollFrame.Background:SetPoint("BOTTOMRIGHT", QuestScrollFrame,"BOTTOMRIGHT", -3, 0)
QuestScrollFrame.Background:SetPoint("TOPLEFT", QuestScrollFrame,"TOPLEFT", 2, 0)

-- show components
frame:Show()
counterFontString:Show()

