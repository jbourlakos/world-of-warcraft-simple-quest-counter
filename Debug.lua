SimpleQuestCounter.Debug = {}
local Debug = SimpleQuestCounter.Debug

local Context = SimpleQuestCounter.Context
local Util = SimpleQuestCounter.Util

function Debug.PrintStatus()
    Util.Console.DPrintf("%s: %d", "Max quests", Context.GetMaxNumQuests())
    Util.Console.DPrintf("%s: %d", "Max standard quests", Context.GetMaxNumStandardQuests())
    Util.Console.DPrintf("%s: %d", "Current standard quests", Context.GetNumStandardQuests())
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

    local questItems = Context.GetAllQuestLogEntries()

    for index, questItem in pairs(questItems) do
        Util.Console.DPrintf("[H:%d][S:%d] %s", questItem.isHeader, questItem.isStandard, questItem.title)
    end

end

function Debug.UIVersion()
     print((select(4, GetBuildInfo())));
end
