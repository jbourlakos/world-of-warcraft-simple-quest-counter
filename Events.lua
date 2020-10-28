-- Module definition
SimpleQuestCounter.Events = {}
local Events = SimpleQuestCounter.Events


-- Attributes
Events.list = {
    -- "ADVENTURE_MAP_QUEST_UPDATE",
    -- "AJ_QUEST_LOG_OPEN",
    -- "QUEST_ACCEPT_CONFIRM",
    -- "QUEST_ACCEPTED",
    -- "QUEST_AUTOCOMPLETE",
    -- "QUEST_BOSS_EMOTE",
    -- "QUEST_COMPLETE",
    -- "QUEST_CURRENCY_LOOT_RECEIVED",
    -- "QUEST_DATA_LOAD_RESULT",
    -- "QUEST_DETAIL",
    -- "QUEST_FINISHED",
    -- "QUEST_GREETING",
    -- "QUEST_ITEM_UPDATE",
    -- "QUEST_LOG_CRITERIA_UPDATE",
    QUEST_LOG_UPDATE = 1,
    -- "QUEST_LOOT_RECEIVED",
    -- "QUEST_POI_UPDATE",
    -- "QUEST_PROGRESS",
    -- "QUEST_REMOVED",
    -- "QUEST_SESSION_CREATED",
    -- "QUEST_SESSION_DESTROYED",
    -- "QUEST_SESSION_ENABLED_STATE_CHANGED",
    -- "QUEST_SESSION_JOINED",
    -- "QUEST_SESSION_LEFT",
    -- "QUEST_SESSION_MEMBER_CONFIRM",
    -- "QUEST_SESSION_MEMBER_START_RESPONSE",
    -- "QUEST_SESSION_NOTIFICATION",
    -- "QUEST_TURNED_IN",
    -- "QUEST_WATCH_LIST_CHANGED",
    -- "QUEST_WATCH_UPDATE",
    -- "UNIT_QUEST_LOG_CHANGED",
    -- "WORLD_QUEST_COMPLETED_BY_SPELL",
}


-- Module API

function Events:GetList()
    return self.list
end


function Events:SubscribeForQuestsEvent(item, handler)
    for event, value in pairs(self.list) do
        item:RegisterEvent(event)
    end
    local genericEventHandler = function(obj, event, ...)
        if (self.list[event]) then
            handler(obj, event, ...)
        end
    end
    item:HookScript("OnEvent", genericEventHandler)
end
