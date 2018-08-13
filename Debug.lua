SimpleQuestCounter.Debug = {}
local Debug = SimpleQuestCounter.Debug

function Debug.PrintAllEntries()
    
    local entriesCount, questsCount = GetNumQuestLogEntries()
    local format = "%3d. %s%s%s%s%s%s%s%s [%d] %s"
    for questLogIndex = 1, entriesCount do

        local title, level, suggestedGroup, isHeader, isCollapsed, 
        isComplete, frequency, questID, startEvent, displayQuestID, 
        isOnMap, hasLocalPOI, isTask, isBounty, isStory, 
        isHidden, isScaling = GetQuestLogTitle(questLogIndex);

        print(string.format(format, 
            questLogIndex, 
            isHeader and "[H]" or "[ ]", 
            isCollapsed and "[C]" or "[ ]", 
            isComplete and "[V]" or "[ ]", 
            isTask and "[T]" or "[ ]", 
            isBounty and "[B]" or "[ ]", 
            isStory and "[S]" or "[ ]", 
            isHidden and "[X]" or "[ ]", 
            isScaling and "[/]" or "[ ]", 
            level, 
            title
        ))
    end
end
