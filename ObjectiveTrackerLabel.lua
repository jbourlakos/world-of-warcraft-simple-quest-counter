if not ObjectiveTrackerBlocksFrame then return end
if not ObjectiveTrackerBlocksFrame.QuestHeader then return end

local Context = SimpleQuestCounter.Context
local Util = SimpleQuestCounter.Util
local S = SimpleQuestCounter.Settings

local questHeader = ObjectiveTrackerBlocksFrame.QuestHeader

local function QuestHeader_OnUpdate(self)
    local questsNumber = Context.GetNumStandardQuests()
    local maxQuestsNumber = Context.GetMaxNumStandardQuests()

    questHeader.Text.originalText = questHeader.Text:GetText()
    questHeader.Text:SetFormattedText(S.fontStringTextFormat, questsNumber, maxQuestsNumber)

    local r,g,b = unpack(Util.CalculateColor(questsNumber, maxQuestsNumber, S.questMinLimitColor, S.questMidLimitColor, S.questMaxLimitColor))
    questHeader.Text:SetTextColor(r,g,b, fontStringAlpha)

end

questHeader:HookScript("OnUpdate", QuestHeader_OnUpdate)
