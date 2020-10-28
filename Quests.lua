----
-- Quest item
----

-- Module definition
SimpleQuestCounter.Quests = {}
local Quests = SimpleQuestCounter.Quests


-- Requirements
if not C_QuestLog then return end
if not C_QuestLog.GetMaxNumQuests then return end
if not C_QuestLog.GetNumQuestLogEntries then return end
if not WorldMapFrame then
    return
else
    Quests.eventFrame = WorldMapFrame
end
local Events = SimpleQuestCounter.Events
local Util = SimpleQuestCounter.Util


-- Attributes
Quests.maxNumQuests = nil
Quests.maxNumStandardQuests = nil
Quests.numShownQuestLogEntries = nil
Quests.numQuestLogEntries = nil
Quests.numStandardQuests = nil
Quests.questLogEntries = nil


----
-- Module API
----

function Quests:PrintStatus()
    local maxNumStandardQuests = Quests:GetMaxNumStandardQuests()
    local numStandardQuests = Quests:GetNumStandardQuests()
    Util.Console.FPrintf("Standard quests: %d (max: %d)", numStandardQuests, maxNumStandardQuests)

    local numCampaignQuests = Quests:GetNumCampaignQuests()
    Util.Console.FPrintf("Campaign quests: %d", numCampaignQuests)

    local numTaskQuests = Quests:GetNumTaskQuests()
    Util.Console.FPrintf("Task quests: %d", numTaskQuests)

    local numBountyQuests = Quests:GetNumBountyQuests()
    Util.Console.FPrintf("Bounty quests: %d", numBountyQuests)

    local numHiddenQuests = Quests:GetNumHiddenQuests()
    Util.Console.FPrintf("Hidden quests: %d", numHiddenQuests)

    local numHeaderEntries = Quests:GetNumHeaderEntries()
    Util.Console.FPrintf("Header entries: %d", numHeaderEntries)

    local maxNumQuests = Quests:GetMaxNumQuests()
    local numNonHeaderQuests = Quests:GetNumNonHeaderQuests()
    Util.Console.FPrintf("Total quests: %d (max: %d)", numNonHeaderQuests, maxNumQuests)
end


function Quests:GetNumHeaderEntries()
    local someQuests = Quests:Select('isHeader')
    return table.getn(someQuests)
end


function Quests:GetNumCampaignQuests()
    local someQuests = Quests:Select('isCampaign')
    return table.getn(someQuests)
end


function Quests:GetNumTaskQuests()
    local someQuests = Quests:Select('isTask')
    return table.getn(someQuests)
end


function Quests:GetNumBountyQuests()
    local someQuests = Quests:Select('isBounty')
    return table.getn(someQuests)
end


function Quests:GetNumHiddenQuests()
    local someQuests = Quests:Select('isHidden')
    return table.getn(someQuests)
end


function Quests:GetNumNonHeaderQuests()
    local function IsNonHeader(elem, index, t)
        return (not elem.isHeader)
    end
    local someQuests = Quests:Select(IsNonHeader)
    return table.getn(someQuests)
end


function Quests:Select(predicate)
    return Util.Table.Select(Quests:GetQuestLogEntries(), predicate)
end


function Quests.All()
    local count = 0
    for index, questItem in pairs(Quests:GetQuestLogEntries()) do
        Util.Console.FPrintf(Quests.ToString(questItem))
    end
    return count
end


function Quests.ToString(questItem)
    return string.format(
        "%s%s%s%s%s%s%s %s",
        questItem.isHeader and '*' or '-',
        questItem.isTask and 'T' or '-',
        questItem.isHidden and 'H' or '-',
        questItem.isBounty and 'B' or '-',
        questItem.isCampaign and 'C' or '-',
        questItem.isScaling and '/' or '-',
        questItem.isStandard and 'S' or '-',
        questItem.title
    )
end


function Quests:GetNumStandardQuests()
    return self.numStandardQuests
end


function Quests:FetchNumStandardQuests()
    local result = 0
    for index, questItem in pairs(self.questLogEntries) do
        if (questItem.isStandard) then
            result = result + 1
        end
    end
    self.numStandardQuests = result
end


function Quests:FetchAll()
    self:FetchMaxNumQuests()
    self:FetchMaxNumStandardQuests()
    self:FetchNumShownQuestLogEntries()
    self:FetchNumQuestLogEntries()
    self:PopulateQuestLogEntries()
    self:FetchNumStandardQuests()
end


function Quests:GetQuestLogEntry(questLogIndex)
    return self.questLogEntries[questLogIndex]
end


function Quests:GetQuestLogEntries()
    return self.questLogEntries
end


function Quests:PopulateQuestLogEntries()
    self.questLogEntries = self.questLogEntries or {}
    -- nullify array entries
    for index = 1, table.getn(self.questLogEntries) do
        self.questLogEntries[index] = nil
    end
    -- populate with every entry
    local numEntries = self:GetNumShownQuestLogEntries()
    for questLogIndex = 1, numEntries do
        -- Blizzard's data
        self.questLogEntries[questLogIndex] = C_QuestLog.GetInfo(questLogIndex)
        local qle = self.questLogEntries[questLogIndex]
        -- Custom data
        qle.isHeader = qle.isHeader or qle.level == 0
        qle.isCampaign = (qle.campaignID ~= nil)
        qle.isStandard = (
            not qle.isHeader and
            not qle.isTask and
            not qle.isHidden and
            not qle.isBounty and
            not qle.isCampaign )
    end
end


function Quests:GetNumQuestLogEntries()
    return self.numQuestLogEntries
end


function Quests:FetchNumQuestLogEntries()
    local _, result = C_QuestLog.GetNumQuestLogEntries()
    self.numQuestLogEntries = result
end


function Quests:GetNumShownQuestLogEntries()
    return self.numShownQuestLogEntries
end


function Quests:FetchNumShownQuestLogEntries()
    local result, _ = C_QuestLog.GetNumQuestLogEntries()
    self.numShownQuestLogEntries = result
end


function Quests:GetMaxNumStandardQuests()
    return self.maxNumStandardQuests
end


function Quests:FetchMaxNumStandardQuests()
    self.maxNumStandardQuests = _G["MAX_QUESTS"] or 25
end


function Quests:GetMaxNumQuests()
    return self.maxNumQuests
end


function Quests:FetchMaxNumQuests()
    self.maxNumQuests = C_QuestLog.GetMaxNumQuests()
end


----
-- Initialize module
----

function Quests._OnQuestsEvent(self, event, ...)
    Quests:FetchAll()
    Util.Console.Printf("Quests: " .. event)
end

-- Quests.eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
-- Quests.eventFrame:HookScript("OnEvent", Quests._OnEvent)
Events:SubscribeForQuestsEvent(Quests.eventFrame, Quests._OnQuestsEvent)
