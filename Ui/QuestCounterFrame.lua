if not WorldMapFrame then return end
local tooltipParent = WorldMapFrame

----
-- Quest counter frame
----

SimpleQuestCounter.Ui.QuestCounterFrame = CreateFrame("Frame", nil, tooltipParent, "InsetFrameTemplate3")
local QuestCounterFrame = SimpleQuestCounter.Ui.QuestCounterFrame

-- Requirements
local Quests = SimpleQuestCounter.Quests
local Events = SimpleQuestCounter.Events
local Util = SimpleQuestCounter.Util
local S = SimpleQuestCounter.Settings

-- basic setup
local tooltip = QuestCounterFrame
tooltip:SetMovable(false)
tooltip:SetResizable(false)


-- background and decoration
-- n/a

-- font and text
tooltip.FontString = tooltip:CreateFontString(nil, S.fontStringDepthDevel, S.fontTemplate)
local fontFileName, previousFontHeight, flags = tooltip.FontString:GetFont()
tooltip.FontString:SetFont(fontFileName, previousFontHeight*S.fontSizeAdjustment, flags)
tooltip.FontString:SetShadowColor(unpack(S.shadowColor))
tooltip.FontString:SetFormattedText(S.fontStringTextFormat, 99, 99) -- default text, to calculate initial dimensions

tooltip.FontString:ClearAllPoints()
tooltip.FontString:SetPoint("CENTER", tooltip)


-- positioning
tooltip:SetPoint("TOPRIGHT", tooltipParent, "BOTTOMRIGHT", -5, 2)

function tooltip._OnQuestsEvent()
    local w = tooltip.FontString:GetWidth() * 1.10
    local h = tooltip.FontString:GetHeight() * 1.60

    local questsNumber = Quests:GetNumCountedQuests()
    local maxQuestsNumber = Quests:GetMaxNumCountedQuests()
    tooltip.FontString:SetFormattedText(S.fontStringTextFormat, questsNumber, maxQuestsNumber)

    local colorScale = questsNumber / maxQuestsNumber
    local r,g,b = unpack(Util.CalculateColor(questsNumber, maxQuestsNumber, S.questMinLimitColor, S.questMidLimitColor, S.questMaxLimitColor))
    tooltip.FontString:SetTextColor(r,g,b, fontStringAlpha)

    tooltip:SetSize(w, h)
end


----
-- Initialize module
----

-- if module is deactivated by Settings
if (not S.activateQuestCounterFrame) then return end

Events:SubscribeForQuestsEvent(tooltip, tooltip._OnQuestsEvent)
