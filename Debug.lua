SimpleQuestCounter.Debug = {}
local Debug = SimpleQuestCounter.Debug

local Quests = SimpleQuestCounter.Quests
local Util = SimpleQuestCounter.Util

function Debug.PrintStatus(params)
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

function Debug.QuestDump(params)
    -- questLogIndex = (type(questLogIndex) == 'number') and questLogIndex or tonumber(questLogIndex)
    questLogIndex = tonumber(params[1])
    local questTable = {}
    questTable.item = C_QuestLog.GetInfo(questLogIndex)
    questTable.tagInfo = C_QuestLog.GetQuestTagInfo(questTable.item.questID)
    Util.Table.PrettyPrint(questTable)
end

function Debug.PrintAllEntries(params)

    local questItems = Quests:GetQuestLogEntries()

    for index, questItem in pairs(questItems) do
        -- Util.Console.DPrintf("[H:%d] %s", questItem.isHeader, questItem.title)
        Util.Console.DPrintf("%2d. %s", index, Quests.ToString(questItem))
    end

end

function Debug.UIVersion(params)
    Util.Console.DPrintf((select(4, GetBuildInfo())));
end

function Debug.Dash(params)
    Util.Console.DPrintf('------')
    Util.Console.DPrintf('------')
end
