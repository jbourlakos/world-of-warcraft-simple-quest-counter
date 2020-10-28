----
-- Module definition
----

SimpleQuestCounter.Ui.QbjectiveTrackerLabel = {}
local ObjectiveTrackerLabel = SimpleQuestCounter.Ui.QbjectiveTrackerLabel


----
-- Requirements
----

if not WorldMapFrame then return end
if not ObjectiveTrackerBlocksFrame then return end
if not ObjectiveTrackerBlocksFrame.QuestHeader then return end

local Quests = SimpleQuestCounter.Quests
local Util = SimpleQuestCounter.Util
local S = SimpleQuestCounter.Settings
local Events = SimpleQuestCounter.Events


----
-- Initialize module
----

local questHeader = ObjectiveTrackerBlocksFrame.QuestHeader

local function QuestHeader_OnQuestsEvent(self)
    local questsNumber = Quests:GetNumStandardQuests()
    local maxQuestsNumber = Quests:GetMaxNumStandardQuests()

    if ( not questsNumber or not maxQuestsNumber ) then
        return
    end

    questHeader.Text.originalText = questHeader.Text:GetText()
    questHeader.Text:SetFormattedText(S.fontStringTextFormat, questsNumber, maxQuestsNumber)

    local r,g,b = unpack(Util.CalculateColor(questsNumber, maxQuestsNumber, S.questMinLimitColor, S.questMidLimitColor, S.questMaxLimitColor))
    questHeader.Text:SetTextColor(r,g,b, fontStringAlpha)

end

-- Events:SubscribeForQuestsEvent(WorldMapFrame, QuestHeader_OnQuestsEvent)
-- Events:SubscribeForQuestsEvent(questHeader, QuestHeader_OnQuestsEvent)
questHeader:HookScript('OnUpdate', QuestHeader_OnQuestsEvent)
