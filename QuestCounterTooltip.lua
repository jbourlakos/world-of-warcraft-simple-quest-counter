if not QuestScrollFrame then return end
if not QuestScrollFrame.DetailFrame then return end
-- if not WorldMapTooltip and not GameTooltip then return end

local tooltipParent = QuestScrollFrame.DetailFrame
local Context = SimpleQuestCounter.Context
local Util = SimpleQuestCounter.Util
local S = SimpleQuestCounter.Settings

SimpleQuestCounter.QuestCounterTooltip = CreateFrame("Frame", nil, tooltipParent, "InsetFrameTemplate3")
QuestCounterTooltip = SimpleQuestCounter.QuestCounterTooltip

-- basic setup
local tooltip = QuestCounterTooltip
tooltip:SetMovable(false)
tooltip:SetResizable(false)


-- background and decoration
-- n/a

-- font and text
tooltip.FontString = tooltip:CreateFontString(nil, S.fontStringDepthDevel, S.fontTemplate)
local fontFileName, previousFontHeight, flags = tooltip.FontString:GetFont()
tooltip.FontString:SetFont(fontFileName, previousFontHeight*S.fontSizeAdjustment, flags)
tooltip.FontString:SetTextColor(unpack(S.questMinLimitColor), S.fontStringAlpha)
tooltip.FontString:SetShadowColor(unpack(S.shadowColor))
tooltip.FontString:SetFormattedText(S.fontStringTextFormat, 99, 99) -- default text, to calculate initial dimensions

tooltip.FontString:ClearAllPoints()
tooltip.FontString:SetPoint("CENTER", tooltip)


-- positioning
tooltip:SetPoint("TOPRIGHT", tooltipParent, "BOTTOMRIGHT", -5, 2)


local function Tooltip_OnUpdate(self)
    local w = tooltip.FontString:GetWidth() * 1.10
    local h = tooltip.FontString:GetHeight() * 1.60

    local questsNumber = Context.GetNumStandardQuests()
    local maxQuestsNumber = Context.GetMaxNumStandardQuests()
    tooltip.FontString:SetFormattedText(S.fontStringTextFormat, questsNumber, maxQuestsNumber)

    local colorScale = questsNumber / maxQuestsNumber
    local r,g,b = unpack(Util.CalculateColor(questsNumber, maxQuestsNumber, S.questMinLimitColor, S.questMidLimitColor, S.questMaxLimitColor))
    tooltip.FontString:SetTextColor(r,g,b, fontStringAlpha)

    tooltip:SetSize(w, h)
end

tooltip:HookScript("OnUpdate", Tooltip_OnUpdate)
