----
-- Context
--
-- This module is the bridge Blizzard functionality.
----

-- Requirements
if not WorldMapFrame then return end
if not C_QuestLog then return end
if not C_QuestLog.GetMaxNumQuests then return end
if not C_QuestLog.GetNumQuestLogEntries then return end


-- Module definition
SimpleQuestCounter.Context = {}
local Context = SimpleQuestCounter.Context


-- Cache attributes
Context._cacheKeyPrefix = '_'
Context._maxNumQuests = nil
Context._maxNumStandardQuests = nil
Context._numShownQuestLogEntries = nil
Context._numQuestLogEntries = nil
Context._questLogEntries = {}


function Context:CacheKeyFor(key)
    return (self._cacheKeyPrefix .. key)
end

-- Cache invalidator for numeric values
function Context:_InvalidateNumeric(...)
    for index, key in pairs(...) do
        local cacheKey = self:_CacheKeyFor(key)
        self[cacheKey] = nil
    end
end


-- Cache invalidator for table values
function Context:_InvalidateTable(...)
    for tableKey, tableObj in pairs(...) do
        local cacheKey = self:_CacheKeyFor(tableKey)
        for index, value in pairs(self[cacheKey]) do
            self[cacheKey][index] = nil -- nullify cell, don't reduce table size
        end
    end
end


function Context:_CacheNumeric(key, newValue)
    local cacheKey = self:_CacheKeyFor(key)
    if (newValue) then
        self[cacheKey] = newValue
    end
    return self[cacheKey]
end


function Context:_CacheTable(key, index, newValue)
    local cacheKey = self:_CacheKeyFor(key)
    if (newValue and index) then
        self[cacheKey][index] = newValue
    end
    if (index) then
        return self[cacheKey][index]
    end
    return self
end


-- A "quest log update" lock and hook
function Context._OnQuestLogUpdate()
end


-- Module initializer
function Context:_Initialize()
    self:_InvalidateNumeric(
        'maxNumQuests',
        'maxNumStandardQuests',
        'numShowQuestLogEntries',
        'numQuestLogEntries'
    )
    self:_InvalidateTable('questLogEntries')
    self:GetMaxNumQuests()
    self:GetMaxNumStandardQuests()

    -- refresh hook
    WorldMapFrame:HookScript("QUEST_LOG_UPDATE", Context._OnQuestLogUpdate)
end

----
-- Module API
----

function Context:GetMaxNumQuests()
    if (not self:_CacheNumeric('maxNumQuests')) then
        self:_CacheNumeric('maxNumQuests', C_QuestLog.GetMaxNumQuests())
    end
    return self:_CacheNumeric('maxNumQuests')
end


function Context:GetMaxNumStandardQuests()
    if (not self:_CacheNumeric('maxNumStandardQuests')) then
        self:_CacheNumeric('maxNumStandardQuests', _G["MAX_QUESTS"] or 25)
    end
    return self:_CacheNumeric('maxNumStandardQuests')
end


function Context:GetNumShownQuestLogEntries()
    if (not self:_CacheNumeric('numShownQuestLogEntries')) then
        local num, _ = C_QuestLog.GetNumQuestLogEntries()
        self:_CacheNumeric('numShownQuestLogEntries', num)
    end
    return self:_CacheNumeric('numShownQuestLogEntries')
end


function Context:GetNumQuestLogEntries()
    if (not self:_CacheNumeric('numQuestLogEntries')) then
        local _, num = C_QuestLog.GetNumQuestLogEntries()
        self:_CacheNumeric('numQuestLogEntries', num)
    end
    return self:_CacheNumeric('numQuestLogEntries')
end


function Context:GetQuestLogEntries()

    local function PopulateQuestLogEntries()
        local questLogEntries
        local numEntries = self:GetNumShownQuestLogEntries()
        for questLogIndex = 1, numEntries do
            questLogEntries[questLogIndex] = C_QuestLog.GetInfo(questLogIndex)
        end
        return questLogEntries
    end

    local tableObj = self:_CacheTable('questLogEntries')
    if (not tableObj) then
        tableObj = self:_CacheTable('questLogEntries', PopulateQuestLogEntries())
    end
    return tableObj
end


----
-- Initialize module
----

Context:_Initialize()
