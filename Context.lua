----
-- Addon Object
----

SimpleQuestCounter = SimpleQuestCounter or {}
local SQC = SimpleQuestCounter -- for convenience

----
-- Context
----

SQC.Context = {
    maxQuests = _G["MAX_QUESTS"],
    tooltipObject = WorldMapTooltip or GameTooltip,
    GetNumQuestLogEntries = GetNumQuestLogEntries,
}
