---
-- Util
--
-- Various general purpose functions
----

SimpleQuestCounter.Util = {}
local Util = SimpleQuestCounter.Util
local S = SimpleQuestCounter.Settings


function Util.CalculateColor(questsNumber, maxQuestsNumber, minLimitColor, midLimitColor, maxLimitColor)
    local result = {}
    local startColor = minLimitColor
    local endColor = maxLimitColor

    local progress = questsNumber / maxQuestsNumber

    if (progress <= 0.5) then
        startColor = minLimitColor
        endColor = midLimitColor
        progress = progress + 0.5
    else
        startColor = midLimitColor
        endColor = maxLimitColor
        progress = progress + 0
    end

    -- for each color component, 1 -> r, 2 -> g, 3 -> b,
    for i=1,3,1 do
        result[i] = startColor[i] + (endColor[i]-startColor[i]) * progress*progress
    end

    return result
end



Util.Console = {}


function Util.Console.GetDefaultChatFrame()
    return DEFAULT_CHAT_FRAME
end

function Util.Console.GetDebugChatFrame()
    local index = 1
    while _G["ChatFrame"..index] do
        local chatFrame = _G["ChatFrame"..index]
        local chatFrameTab = _G["ChatFrame"..index.."Tab"]
        local chatFrameTabText = _G["ChatFrame"..index.."TabText"]
        -- TODO: what happens if "Debug log" is closed; it remains in memory
        if chatFrame and chatFrameTab and chatFrameTabText and chatFrameTabText:GetText() == "Debug Log" then
            return chatFrame
        end
        index = index + 1
    end
    return DEFAULT_CHAT_FRAME
end

function Util.Console.GetCurrentChatFrame()
    return SimpleQuestCounter.currentChatFrame or Util.Console.GetDefaultChatFrame()
end

function Util.Console.Print(...)
    local defaultChatFrame = Util.Console.GetDefaultChatFrame()
    defaultChatFrame:AddMessage(...)
end

function Util.Console.DPrint(...)
    local debugChatFrame = Util.Console.GetDebugChatFrame()
    debugChatFrame:AddMessage(...)
end

function Util.Console.Printf(format, ...)
    Util.Console.Print(string.format(format, ...))
end

function Util.Console.DPrintf(format, ...)
    Util.Console.DPrint(string.format(format, ...))
end

function Util.Console.FPrintf(format, ...)
    local currentChatFrame = Util.Console.GetCurrentChatFrame()
    currentChatFrame:AddMessage(string.format(format,...))
end

Util.String = {}

function Util.String.Split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
