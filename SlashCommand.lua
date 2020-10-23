SimpleQuestCounter.SlashCommand = {}
local SlashCommand = SimpleQuestCounter.SlashCommand

local Util = SimpleQuestCounter.Util
local Debug = SimpleQuestCounter.Debug
-- local Quests = SimpleQuestCounter.Quests

SlashCommand.baseCommandName = 'sqc'

function SlashCommand.Value()
    return "/"..SlashCommand.baseCommandName
end

function SlashCommand.GlovalValue()
    return string.upper(SlashCommand.baseCommandName)
end

function SlashCommand.UnsupportedCommand(cmd)
    print("SimpleQuestCounter: command " .. cmd .. " is not supported.\nSupported command: /sqc info")
end

function SlashCommand.Dispatch(msg, editBox)
    -- mark the current chat frame
    SimpleQuestCounter.currentChatFrame = editBox and editBox.chatFrame

    -- parse command and args
    local argv = Util.String.Split(msg)
    local command = table.remove(argv, 1)
    local params = argv

    -- default command
    if command == nil then
        command = 'info'
    end

    -- dispatch
    command = string.lower(command)
    if command == 'info' then
        (Quests or Debug).PrintStatus()
    elseif command == '_dbg' then
        Debug.PrintAllEntries()
    elseif command == '_q' then
        local questLogIndex = params[1]
        local attribute = params[2]
        Debug.QuestInfo(questLogIndex, attribute)
    elseif command == '_select' then
        local predicate = params[1]
        Quests.Select(predicate)
    elseif command == '_all' then
        Quests.All()
    else
        SlashCommand.UnsupportedCommand(msg)
    end
end

SLASH_SQC1 = SlashCommand.Value()
-- SLASH_SQC2 = < other value >

SlashCmdList[SlashCommand.GlovalValue()] = SlashCommand.Dispatch
