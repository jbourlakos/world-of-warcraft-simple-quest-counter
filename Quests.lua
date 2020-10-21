SimpleQuestCounter.Quests = {}
local Quests = SimpleQuestCounter.Quests

local Util = SimpleQuestCounter.Util
local Context = SimpleQuestCounter.Context

function Quests.PrintStatus()


    local maxNumStandardQuests = Context.GetMaxNumStandardQuests()
    local numStandardQuests = Context.GetNumStandardQuests()
    Util.Console.Printf("Standard quests: %d / %d", numStandardQuests, maxNumStandardQuests)

    local numCampaignQuests = Context.GetNumCampaignQuests()
    Util.Console.Printf("Campaign quests: %d", numCampaignQuests)

    local numTaskQuests = Context.GetNumTaskQuests()
    Util.Console.Printf("Task quests: %d", numTaskQuests)

    local numBountyQuests = Context.GetNumBountyQuests()
    Util.Console.Printf("Bounty quests: %d", numBountyQuests)

    local numHiddenQuests = Context.GetNumHiddenQuests()
    Util.Console.Printf("Hidden quests: %d", numHiddenQuests)

    local maxNumQuests = Context.GetMaxNumQuests()
    local numNonHeaderQuests = Context.GetNumNonHeaderQuests()
    Util.Console.Printf("Total quests: %d / %d", numNonHeaderQuests, maxNumQuests)
end
