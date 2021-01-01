
SimpleQuestCounter.Ui.QuestLogEntries = {}
local QuestLogEntries = SimpleQuestCounter.Ui.QuestLogEntries

if not QuestLogQuests_Update then return end
if not QuestScrollFrame then return end
if not QuestScrollFrame.headerFramePool then return end

local Events = SimpleQuestCounter.Events
local Quests = SimpleQuestCounter.Quests
local S = SimpleQuestCounter.Settings



function QuestLogEntries.CalculateQuestCountPerHeader()
    local countPerHeader = {}
    local currentHeader = nil

    for index, questItem in pairs(Quests:GetQuestLogEntries()) do
        if (questItem.isLikeHeader) then
            currentHeader = questItem.title
            if not countPerHeader[currentHeader] then
                -- a header might appear more than once
                countPerHeader[currentHeader] = 0
            end
        elseif (questItem.isCounted) then
            countPerHeader[currentHeader] = countPerHeader[currentHeader] + 1
        else
            -- do nothing
        end
    end

    return countPerHeader
end



----
-- Initialize module
----

-- if module is deactivated by Settings
if (not S.activateQuestLogEntries) then return end

function QuestLogEntries._OnQuestsEvent(self, event, ...)
    local qHeaderPool = QuestScrollFrame.headerFramePool

    -- if not enough headers
    if qHeaderPool:GetNumActive() <= 0 then return end

    -- calculate quest count per header
    local questCountPerHeader = QuestLogEntries.CalculateQuestCountPerHeader()

    -- enumerate all quest headers
    for currentQHeader, _ in qHeaderPool:EnumerateActive() do
        local title = currentQHeader:GetText()
        title = string.format("(|cFFFFD100%d|r) %s", questCountPerHeader[title], title)
        currentQHeader:SetText(title)
    end

end

Events:SubscribeForQuestsEvent(QuestScrollFrame, QuestLogEntries._OnQuestsEvent)
