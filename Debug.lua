SimpleQuestCounter.Debug = {}
local Debug = SimpleQuestCounter.Debug

local Quests = SimpleQuestCounter.Quests
local Util = SimpleQuestCounter.Util

function Debug.PrintStatus()
    Util.Console.DPrintf("%s: %d", "Max quests", Quests:GetMaxNumQuests())
    Util.Console.DPrintf("%s: %d", "Max counted quests", Quests:GetMaxNumCountedQuests())
    Util.Console.DPrintf("%s: %d", "Current counted quests", Quests:GetNumQuestLogEntries())
end

function Debug.QuestInfo(questLogIndex, attribute)
    local questInfo = C_QuestLog.GetInfo(questLogIndex)
    local value = questInfo[attribute]

    local value_type = type(value)
    local fmt = ""
    if value_type == 'string' then
        fmt = "%s: %s"
    elseif value_type == 'number' then
        fmt = "%s: %d"
    elseif value_type == 'boolean' then
        fmt = "%s: %d"
    elseif value_type == 'nil' then
        fmt = "%s: nil"
    elseif value_type == 'function' then
        fmt = "%s: function"
    else
        -- invalid type
    end

    Util.Console.DPrintf(fmt, attribute, value)
end

function Debug.PrintAllEntries()

    local questItems = Quests:GetQuestLogEntries()

    for index, questItem in pairs(questItems) do
        -- Util.Console.DPrintf("[H:%d] %s", questItem.isHeader, questItem.title)
        Util.Console.DPrintf("%s", Quests.ToString(questItem))
    end

end

function Debug.UIVersion()
     print((select(4, GetBuildInfo())));
end
