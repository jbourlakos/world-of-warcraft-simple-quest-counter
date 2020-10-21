----
-- Context
--
-- This module is the bridge to connect with Blizzard functionality.
----

if not C_QuestLog then return end
if not C_QuestLog.GetMaxNumQuests then return end

SimpleQuestCounter.Context = {}
local Context = SimpleQuestCounter.Context

function Context.GetMaxNumQuests()
    return C_QuestLog.GetMaxNumQuests()
end

function Context.GetMaxNumStandardQuests()
    return _G["MAX_QUESTS"] or 25
end

function Context.GetNumShownQuestLogEntries()
    local numEntries, _ = C_QuestLog.GetNumQuestLogEntries()
    return numEntries
end

function Context.GetNumQuests()
    local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
    return numQuests
end

function Context.GetAllQuestLogEntries()
    -- get quest log counters
    local numEntries = Context.GetNumShownQuestLogEntries()

    -- this is the result array
    local result = {}

    -- convert each quest log item to a custom item, with custom fields
    for questLogIndex = 1, numEntries do
        local questLogItem = C_QuestLog.GetInfo(questLogIndex)

        local customItem = {}

        -- title
        customItem.title = questLogItem.title
        -- is header
        customItem.isHeader = questLogItem.isHeader or questLogItem.level == 0
        -- is task
        customItem.isTask = questLogItem.isTask
        -- is bounty
        customItem.isBounty = questLogItem.isBounty
        -- is campaign
        customItem.isCampaign = (questLogItem.campaignID ~= nil)
        -- is hidden
        customItem.isHidden = questLogItem.isHidden
        -- is standard
        customItem.isStandard =
            not customItem.isHeader and
            not questLogItem.isTask and
            not questLogItem.isHidden and
            not questLogItem.isBounty and
            questLogItem.campaignID == nil

        -- add to result array
        table.insert(result, customItem)

    end

    return result
end

-- Equivalent to the legacy top-level GetQuestLogTitle() function
function Context.GetQuestLogTitle(questLogIndex)
    local qi = C_QuestLog.GetInfo(questLogIndex)
    return {
        qi.title,
        qi.level,
        qi.suggestedGroup,
        qi.isHeader,
        qi.isCollapsed,
        nil, -- qi.isComplete,
        qi.frequency,
        qi.questID,
        qi.startEvent,
        qi.displayQuestID,
        qi.isOnMap,
        qi.hasLocalPOI,
        qi.isTask,
        qi.isBounty,
        qi.isStory,
        qi.isHidden,
        qi.isScaling
    }
end

function Context.GetNumStandardQuests()
    -- return C_QuestLog.GetNumQuestLogEntries()
    local count = 0
    for index, questItem in pairs(Context.GetAllQuestLogEntries()) do
        if questItem.isStandard then
            count = count + 1
        end
    end
    return count
end

function Context.GetNumNonHeaderQuests()
    local count = 0
    for index, questItem in pairs(Context.GetAllQuestLogEntries()) do
        if not questItem.isHeader then
            count = count + 1
        end
    end
    return count
end


function Context.GetNumCampaignQuests()
    local count = 0
    for index, questItem in pairs(Context.GetAllQuestLogEntries()) do
        if questItem.isCampaign then
            count = count + 1
        end
    end
    return count
end

function Context.GetNumTaskQuests()
    local count = 0
    for index, questItem in pairs(Context.GetAllQuestLogEntries()) do
        if questItem.isTask then
            count = count + 1
        end
    end
    return count
end

function Context.GetNumBountyQuests()
    local count = 0
    for index, questItem in pairs(Context.GetAllQuestLogEntries()) do
        if questItem.isBounty then
            count = count + 1
        end
    end
    return count
end

function Context.GetNumHiddenQuests()
    local count = 0
    for index, questItem in pairs(Context.GetAllQuestLogEntries()) do
        if questItem.isHidden then
            count = count + 1
        end
    end
    return count
end
