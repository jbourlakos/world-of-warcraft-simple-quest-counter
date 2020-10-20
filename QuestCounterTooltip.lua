if not QuestScrollFrame then return end
if not QuestScrollFrame.DetailFrame then return end
-- if not WorldMapTooltip and not GameTooltip then return end

local tooltipParent = QuestScrollFrame.DetailFrame
local Context = SimpleQuestCounter.Context
local S = SimpleQuestCounter.Settings

SimpleQuestCounter.QuestCounterTooltip = CreateFrame("Frame", nil, tooltipParent)
QuestCounterTooltip = SimpleQuestCounter.QuestCounterTooltip

-- basic setup
local tooltip = QuestCounterTooltip
tooltip:SetMovable(false)
tooltip:SetResizable(false)

-- background and decoration
-- tooltip:SetBackdropColor(unpack(S.backdropColor))
tooltip.Texture = tooltip:CreateTexture(nil, "BACKGROUND")
tooltip.Texture:SetAllPoints()
-- tooltipTexture:SetColorTexture(1, 1, 1, 0.5)
tooltip.Texture:SetColorTexture(0, 0, 0, 0.75)
tooltip.Texture:SetVertexColor(0.5, 0.5, 0.5, 0.5)

-- font and text
tooltip.FontString = tooltip:CreateFontString(nil, S.fontStringDepthDevel, S.fontTemplate)
local fontFileName, previousFontHeight, flags = tooltip.FontString:GetFont()
tooltip.FontString:SetFont(fontFileName, previousFontHeight*S.fontSizeAdjustment, flags)
tooltip.FontString:SetTextColor(unpack(S.questMinLimitColor), S.fontStringAlpha)
tooltip.FontString:SetShadowColor(unpack(S.shadowColor))
tooltip.FontString:SetFormattedText(S.fontStringTextFormat, 99, 99) -- default text, to calculate initial dimensions
tooltip.FontString:SetPoint("CENTER", tooltip)

-- positioning
tooltip:SetPoint("TOPRIGHT",tooltipParent, "BOTTOMRIGHT", 0, 0)


function QuestCounterTooltip.CalculateColor(questsNumber, maxQuestsNumber, minLimitColor, midLimitColor, maxLimitColor)
    local result = {}
    local startColor = minLimitColor
    local endColor = maxLimitColor

    local progress = questsNumber / maxQuestsNumber

    if (progress <= 0.5) then
        startColor = minLimitColor
        endColor = midLimitColor
        progress = progress + 0.5
    else
        startColor = midLimitColor
        endColor = maxLimitColor
        progress = progress + 0
    end

    -- for each color component, 1 -> r, 2 -> g, 3 -> b,
    for i=1,3,1 do
        result[i] = startColor[i] + (endColor[i]-startColor[i]) * progress*progress
    end

    return result
end



local function Tooltip_OnUpdate(self)
    local w = tooltip.FontString:GetWidth()
    local h = tooltip.FontString:GetHeight()

    local questsNumber = Context.GetNumStandardQuests()
    local maxQuestsNumber = Context.GetMaxNumStandardQuests()
    tooltip.FontString:SetFormattedText(S.fontStringTextFormat, questsNumber, maxQuestsNumber)

    local colorScale = questsNumber / maxQuestsNumber
    local r,g,b = unpack(QuestCounterTooltip.CalculateColor(questsNumber, maxQuestsNumber, S.questMinLimitColor, S.questMidLimitColor, S.questMaxLimitColor))
    tooltip.FontString:SetTextColor(r,g,b, fontStringAlpha)

    tooltip:SetSize(w, h)
end

tooltip:HookScript("OnUpdate", Tooltip_OnUpdate)
