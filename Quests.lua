SimpleQuestCounter.Quests = {}
local Quests = SimpleQuestCounter.Quests

local Util = SimpleQuestCounter.Util
local Context = SimpleQuestCounter.Context


function Quests.PrintStatus()
    local maxNumStandardQuests = Context.GetMaxNumStandardQuests()
    local numStandardQuests = Context.GetNumStandardQuests()
    Util.Console.FPrintf("Standard quests: %d / %d", numStandardQuests, maxNumStandardQuests)

    local numCampaignQuests = Context.GetNumCampaignQuests()
    Util.Console.FPrintf("Campaign quests: %d", numCampaignQuests)

    local numTaskQuests = Context.GetNumTaskQuests()
    Util.Console.FPrintf("Task quests: %d", numTaskQuests)

    local numBountyQuests = Context.GetNumBountyQuests()
    Util.Console.FPrintf("Bounty quests: %d", numBountyQuests)

    local numHiddenQuests = Context.GetNumHiddenQuests()
    Util.Console.FPrintf("Hidden quests: %d", numHiddenQuests)

    local maxNumQuests = Context.GetMaxNumQuests()
    local numNonHeaderQuests = Context.GetNumNonHeaderQuests()
    Util.Console.FPrintf("Total quests: %d / %d", numNonHeaderQuests, maxNumQuests)
end


function Quests.Select(predicate)
    local count = 0
    for index, questItem in pairs(Context.GetAllQuestLogEntries()) do
        if questItem[predicate] then
            Util.Console.FPrintf(Quests.ToString(questItem))
        end
    end
    return count
end


function Quests.All()
    local count = 0
    for index, questItem in pairs(Context.GetAllQuestLogEntries()) do
        Util.Console.FPrintf(Quests.ToString(questItem))
    end
    return count
end


function Quests.ToString(questItem)
    return string.format(
        "[%s][%s][%s][%s][%s][%s][%s] %s",
        questItem.isHeader and '*' or ' ',
        questItem.isTask and 'T' or ' ',
        questItem.isHidden and 'H' or ' ',
        questItem.isBounty and 'B' or ' ',
        questItem.isCampaign and 'C' or ' ',
        questItem.isScaling and '/' or ' ',
        questItem.isStandard and 'S' or ' ',
        questItem.title
    )
end
