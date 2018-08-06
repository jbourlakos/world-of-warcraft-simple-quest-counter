if not QuestLogQuests_Update then return end
if not QuestScrollFrame then return end
if not QuestScrollFrame.headerFramePool then return end



SimpleQuestCounter.QuestLogEntries = {}
local QuestLogEntries = SimpleQuestCounter.QuestLogEntries



-- override the default QuestLogQuests_Update global function (from QuestMapFrame.lua)
-- first, store the default implementation
QuestLogEntries.__QuestLogQuests_Update = QuestLogQuests_Update
-- then, override
_G.QuestLogQuests_Update = function(poiTable)

    local Default_QuestLogQuests_Update = QuestLogEntries.__QuestLogQuests_Update
    local qHeaderPool = QuestScrollFrame.headerFramePool
    local returnValue = nil

    -- if not enough headers
    if qHeaderPool:GetNumActive() <= 0 then
        return Default_QuestLogQuests_Update(poiTable)
    end

    -- execute default function
    returnValue = Default_QuestLogQuests_Update(poiTable)

    -- calculate quest count per header
    local questCountPerHeader = QuestLogEntries.CalculateQuestCountPerHeader()

    -- enumerate all quest headers
    for currentQHeader, _ in qHeaderPool:EnumerateActive() do
        local title = currentQHeader:GetText()
        title = string.format("(|cFFFFD100%d|r) %s", questCountPerHeader[title], title)
        currentQHeader:SetText(title)
    end

    return returnValue

end



function QuestLogEntries.CalculateQuestCountPerHeader()
    local countPerHeader = {}
    local currentHeader = nil
    local entriesCount, questsCount = GetNumQuestLogEntries()
    for i = 1, entriesCount, 1 do
        local qTitle, _, _, qIsHeader, _, _, _, _, _, _, _, _, qIsTask, _  = GetQuestLogTitle(i)
        if (qIsHeader) then
            currentHeader = qTitle
            if countPerHeader[currentHeader] == nil then -- a header might appear more than once
                countPerHeader[currentHeader] = 0
            end
        elseif (not qIsHeader and not qIsTask) then
            countPerHeader[currentHeader] = countPerHeader[currentHeader] + 1
        end
    end
    return countPerHeader
end